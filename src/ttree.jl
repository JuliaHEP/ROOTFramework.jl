# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TTree.h")
cxxinclude("TChain.h")

export create_ttree!
export bind_branch!
export create_branch!
export getname
export gettitle


export TTreePtr
typealias TTreePtr pcpp"TTree"

export TChain, TChainPtr, TChainInst
typealias TChain cxxt"TChain"
typealias TChainPtr pcpp"TChain"
typealias TChainInst Union{TChain, TChainPtr}

export ATTreeInst
typealias ATTreeInst Union{TTreePtr, TChainInst}


create_ttree!(tdir::ATDirectoryInst, name::AbstractString, title::AbstractString) =
    cd(() -> icxx""" new TTree($name, $title); """, tdir)


Base.size(ttree::ATTreeInst) = (length(ttree),)
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


bind_branch!{T<:Union{Number, Cxx.CppPtr}}(ttree::ATTreeInst, name::AbstractString, value::Ref{T}) = begin
    @cxx ttree->SetBranchStatus(pointer(name), true);
    @cxx ttree->AddBranchToCache(pointer(name), true);
    @cxx ttree->SetBranchAddress(pointer(name), icxx"&$value;")
end

create_branch!{T<:Union{Number, Cxx.CppPtr}}(ttree::TTreePtr, name::AbstractString, value::Ref{T}; bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """

create_branch!(ttree::TTreePtr, name::AbstractString, value::Cxx.CppValue; bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """
