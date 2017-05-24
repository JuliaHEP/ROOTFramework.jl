# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

export TTreeBindings
export TTreeInput
export TTreeOutput
export TChainInput

export ttree_binding_proxy


type TTreeBindings
    values::Dict{Symbol, Any}
    direct_values::Dict{Symbol, Any}
    proxied_values::Dict{Symbol, Pair{Any, Any}}

    TTreeBindings() = new(
        Dict{Symbol, Any}(),
        Dict{Symbol, Any}(),
        Dict{Symbol, Pair{Any, Any}}()
    )
end


Base.getindex(bindings::TTreeBindings, key::Symbol) = bindings.values[key]

Base.setindex!(bindings::TTreeBindings, value::Any, key::Symbol) = begin
    bindings.values[key] = value

    const proxy = ttree_binding_proxy(value)
    if proxy == nothing
        # info("Binding branch name $(key) to value of type $(typeof(value))")
        haskey(bindings.proxied_values, key) && delete!(bindings.proxied_values, key)
        bindings.direct_values[key] = value
    else
        # info("Binding branch name  $(key) to value of type $(typeof(value)) via proxy of type $(typeof(proxy))")
        haskey(bindings.direct_values, key) && delete!(bindings.direct_values, key)
        bindings.proxied_values[key] = Pair{Any, Any}(value, proxy)
    end

    bindings
end


copy_to_proxies!(bindings::TTreeBindings) = begin
    for (_, (value, proxy_value)) in bindings.proxied_values
        copy!(proxy_value, value)
    end
end

copy_from_proxies!(bindings::TTreeBindings) = begin
    for (_, (value, proxy_value)) in bindings.proxied_values
        copy!(value, proxy_value)
    end
end


bind_branches!(ttree::ATTreeInst, bindings::TTreeBindings) = begin
    for (key, value) in bindings.direct_values
        # info("Binding branch $(string(key)) of type $(typeof(value)) in $(ttree)")
        bind_branch!(ttree, string(key), value)
    end
    for (key, (_, proxy)) in bindings.proxied_values
        # info("Binding branch $(string(key)) of type $(typeof(proxy)) in $(ttree)")
        bind_branch!(ttree, string(key), proxy)
    end
end

create_branches!(ttree::ATTreeInst, bindings::TTreeBindings) = begin
    for (key, value) in bindings.direct_values
        # info("Creating branch $(string(key)) of type $(typeof(value)) in $(ttree)")
        create_branch!(ttree, string(key), value)
    end
    for (key, (_, proxy)) in bindings.proxied_values
        # info("Creating branch $(string(key)) of type $(typeof(proxy)) in $(ttree)")
        create_branch!(ttree, string(key), proxy)
    end
end


ttree_binding_proxy{T<:Union{Cxx.CxxBuiltinTs, Cxx.CppPtr}}(value::Ref{T}) = nothing



immutable CxxObjWithPtrRef{T,N,CVR}
    x::Cxx.CppValue{T,N}
    ptrref::Ref{Cxx.CppPtr{T,CVR}}
end

CxxObjWithPtrRef(x::Cxx.CppValue) = CxxObjWithPtrRef(x, Ref(icxx"&$x;"))

bind_branch!(ttree::ATTreeInst, name::AbstractString, value::CxxObjWithPtrRef) =
   bind_branch!(ttree, name, value.ptrref)

create_branch!(ttree::ATTreeInst, name::AbstractString, value::CxxObjWithPtrRef; kwargs...) =
   create_branch!(ttree, name, value.ptrref, kwargs...)

ttree_binding_proxy(value::CxxObjWithPtrRef) = nothing

Base.copy!(a, b::CxxObjWithPtrRef) = copy!(a, b.x)
Base.copy!(a::CxxObjWithPtrRef, b) = copy!(a.x, b)
Base.copy!(a::CxxObjWithPtrRef, b::CxxObjWithPtrRef) = copy!(a.x, b.x)


ttree_binding_proxy{T}(value::AbstractVector{T}) = CxxObjWithPtrRef(icxx"std::vector<$T>();")
Base.copy!(a::AbstractVector, b::CxxObjWithPtrRef) = (resize!(a, length(b.x)); copy!(a, b.x))
Base.copy!(a::CxxObjWithPtrRef, b::AbstractVector) = (resize!(a.x, length(b)); copy!(a.x, b))



type TTreeInput <: AbstractVector{Void}
    ttree::ATTreeInst
    bindings::TTreeBindings

    TTreeInput(ttree::ATTreeInst, bindings::TTreeBindings) = begin
        input = new(ttree, bindings)
        bind_branches!(ttree, bindings)
        input
    end
end


Base.show(io::IO, x::TTreeInput) = show(io, MIME"text/plain"(), x)
Base.show(io::IO, ::MIME"text/plain", x::TTreeInput) = Base.show_default(io, x)

Base.size(input::TTreeInput) = (length(input.ttree),)

Base.getindex(input::TTreeInput, i::Integer) = begin
    result = getindex(input.ttree, i)
    copy_from_proxies!(input.bindings)
    result
end


type TChainInput <: AbstractVector{Void}
    tchain::TChainPtr
    bindings::TTreeBindings
end


function Base.open(::Type{TChainInput}, bindings::TTreeBindings, treename::AbstractString, filenames::AbstractString...; wildcards::Bool = false)
    tchain = lock(gROOTMutex()) do
        icxx"new TChain($treename);"
    end

    if wildcards
        for filename in filenames
            @cxx tchain->Add(pointer(filename))
        end
    else
        for filename in filenames
            @cxx tchain->AddFile(pointer(filename))
        end
    end

    @cxx tchain->SetCacheSize(-1);
    @cxx tchain->SetBranchStatus(pointer("*"), false);
    bind_branches!(tchain, bindings)

    result = TChainInput(tchain, bindings)
    finalizer(result, close)
    result
end


Base.show(io::IO, x::TChainInput) = show(io, MIME"text/plain"(), x)
Base.show(io::IO, ::MIME"text/plain", x::TChainInput) = Base.show_default(io, x)


Base.open(::Type{TChainInput}, treename::AbstractString, filenames::AbstractString...; kwargs...) =
    open(TChainInput, TTreeBindings(), treename, filenames...; kwargs...)

Base.isopen(input::TChainInput) = (input.tchain != C_NULL)

function Base.close(input::TChainInput)
    if isopen(input)
        tchain = lock(gROOTMutex()) do
            icxx"delete $(input.tchain);"
        end
        input.tchain = icxx"(TChain*)(nullptr);"
    end
    nothing
end


Base.size(input::TChainInput) = (length(input.tchain),)

Base.getindex(input::TChainInput, i::Integer) = begin
    result = getindex(input.tchain, i)
    copy_from_proxies!(input.bindings)
    result
end


type TTreeOutput
    ttree::TTreePtr
    bindings::TTreeBindings

    TTreeOutput(ttree::TTreePtr, bindings::TTreeBindings) = begin
        output = new(ttree, bindings)
        create_branches!(ttree, bindings)
        output
    end
end


push!(output::TTreeOutput) = begin
    copy_to_proxies!(output.bindings)
    push!(output.ttree)
    nothing
end
