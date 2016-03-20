# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: show, push!, getindex, setindex!, isopen, open, close, write


export TTreeOutput

export create_ttree!
export create_branch!
export getname
export gettitle
export connect_branch!
export getproxy


create_ttree!(tdir::ATDirectoryInst, name::AbstractString, title::AbstractString) =
    @tmp_tdir_cd tdir icxx""" new TTree($name, $title); """

create_branch!{T<:Union{Number, Cxx.CppPtr}}(ttree::TTreePtr, name::AbstractString, value::Ref{T}, bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """

create_branch!(ttree::TTreePtr, name::AbstractString, value::Cxx.CppValue, bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """

push!(ttree::TTreePtr) = icxx""" $ttree->Fill(); """



show(io::IO, x::TChain) = print(io, "TChain(\"$(escape_string(getname(x)))\")")


getname(obj::ATTreeInst) = bytestring(@cxx obj->GetName())

gettitle(obj::ATTreeInst) = bytestring(@cxx obj->GetTitle())

connect_branch!{T<:Number}(ttree::ATTreeInst, name::AbstractString, value::Ref{T}) =
    icxx""" $ttree->SetBranchAddress($name, &$value); """


cxx"""
    template<typename T> struct BranchValue {
        T* value = nullptr;
        template<typename... Args> BranchValue(Args&&... args)
            : value(new T(std::forward<Args>(args)...)) {}
        ~BranchValue() { if (value != nullptr) delete value; }
    };
"""

typealias BranchValue{T} cxxt"BranchValue<$T>"



ttree_proxy_value{T<:Union{Number, Cxx.CppPtr}}(value::Ref{T}) = nothing



type TTreeOutput
    name::AbstractString
    title::AbstractString
    values::Dict{Symbol, Any}
    direct_values::Dict{Symbol, Any}
    proxied_values::Dict{Symbol, Pair{Any, Any}}
    ttree::ATTreeInst

    TTreeOutput(name::AbstractString, title::AbstractString) = new(
        name, title,
        Dict{Symbol, Any}(),
        Dict{Symbol, Any}(),
        Dict{Symbol, Pair{Any, Any}}(),
        TTreePtr(Ptr{Void}(0))
    )
end


getindex(output::TTreeOutput, key::Symbol) = output.values[key]

getproxy(output::TTreeOutput, key::Symbol) = output.proxied_values[key].second


setindex!(output::TTreeOutput, value::Any, key::Symbol) = begin
    isopen(output) && error("Can't add values to TTreeOutput while open")

    output.values[key] = value

    const proxy = ttree_proxy_value(value)
    if proxy == nothing
        # info("Adding branch $(key) of type $(typeof(value)) to TTreeOutput")
        output.direct_values[key] = value
    else
        # info("Adding branch $(key) of type $(typeof(value)) to TTreeOutput via proxy of type $(typeof(proxy))")
        output.proxied_values[key] = Pair{Any, Any}(value, proxy)
    end

    output
end


isopen(output::TTreeOutput) = output.ttree != TTreePtr(Ptr{Void}(0))


open(output::TTreeOutput, tdir::ATDirectoryInst) = begin
    close(output)
    # info("Creating ttree $(output.name) in $(tdir)")
    output.ttree = create_ttree!(tdir, output.name, output.title)
    for (key, value) in output.direct_values
        # info("Creating branch $(string(key)) of type $(typeof(value)) in $(output.ttree)")
        create_branch!(output.ttree, string(key), value)
    end
    for (key, (_, proxy)) in output.proxied_values
        # info("Creating branch $(string(key)) of type $(typeof(proxy)) in $(output.ttree)")
        create_branch!(output.ttree, string(key), proxy)
    end
end


close(output::TTreeOutput) = begin
    if isopen(output)
        const ttree = output.ttree
        output.ttree = TTreePtr(Ptr{Void}(0))
    end
end


push!(output::TTreeOutput) = begin
    assert(isopen(output))
    for (_, (value, proxy)) in output.proxied_values
        set_proxy_from_value!(proxy, value)
    end
    push!(output.ttree)

    nothing
end
