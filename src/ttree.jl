# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

export create_ttree!
export bind_branch!
export create_branch!
export getname
export gettitle


create_ttree!(tdir::ATDirectoryInst, name::AbstractString, title::AbstractString) =
    cd(() -> icxx""" new TTree($name, $title); """, tdir)


Base.size(ttree::ATTreeInst) = (length(),)
Base.length(ttree::ATTreeInst) = Int(@cxx ttree->GetEntries())

Base.getindex(ttree::ATTreeInst, i::Integer) = begin
    @cxx ttree->GetEntry(i - 1)
    nothing
end

Base.start(ttree::ATTreeInst) = 1
Base.next(ttree::ATTreeInst, i::Integer) = ( getindex(ttree, i), i+1 )
Base.done(ttree::ATTreeInst, i::Integer) = i > length(ttree)

Base.push!(ttree::TTreePtr) = icxx""" $ttree->Fill(); """

getname(obj::ATTreeInst) = unsafe_string(@cxx obj->GetName())
gettitle(obj::ATTreeInst) = unsafe_string(@cxx obj->GetTitle())


bind_branch!{T<:Union{Number, Cxx.CppPtr}}(ttree::ATTreeInst, name::AbstractString, value::Ref{T}) =
    @cxx ttree->SetBranchAddress(pointer(name), icxx"&$value;")

create_branch!{T<:Union{Number, Cxx.CppPtr}}(ttree::TTreePtr, name::AbstractString, value::Ref{T}; bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """

create_branch!(ttree::TTreePtr, name::AbstractString, value::Cxx.CppValue; bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """



TChain(tree_name::AbstractString, file_names::AbstractString...; wildcards::Bool = false) = begin
    tchain = @cxx TChain(pointer(tree_name))
    for f in file_names
        push!(tchain, f, wildcards = wildcards)
    end
    tchain
end

Base.show(io::IO, x::TChain) = print(io, "TChain(\"$(escape_string(getname(x)))\")")


Base.push!(tchain::TChainInst, file_name::AbstractString; wildcards::Bool = false) = begin
    if wildcards
        @cxx tchain->Add(pointer(file_name))
    else
        @cxx tchain->AddFile(pointer(file_name))
    end
    tchain
end
