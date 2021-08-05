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
const TTreePtr = pcpp"TTree"

export TChain, TChainPtr, TChainInst
const TChain = cxxt"TChain"
const TChainPtr = pcpp"TChain"
const TChainInst = Union{TChain, TChainPtr}

export ATTreeInst
const ATTreeInst = Union{TTreePtr, TChainInst}


create_ttree!(tdir::ATDirectoryInst, name::AbstractString, title::AbstractString) =
    cd(() -> icxx""" new TTree($name, $title); """, tdir)


Base.size(ttree::ATTreeInst) = (length(ttree),)
Base.length(ttree::ATTreeInst) = Int(@cxx ttree->GetEntries())
Base.firstindex(ttree::ATTreeInst) = 1
Base.lastindex(ttree::ATTreeInst) = length(ttree)

Base.getindex(ttree::ATTreeInst, i::Integer) = begin
    @cxx ttree->GetEntry(i - 1)
    nothing
end


Base.iterate(ttree::ATTreeInst) = iterate(ttree, firstindex(ttree))

function Base.iterate(ttree::ATTreeInst, i::Integer)
    if i <= lastindex(ttree)
        ( getindex(ttree, i), i+1 )
    else
        nothing
    end
end


Base.push!(ttree::TTreePtr) = icxx""" $ttree->Fill(); """

getname(obj::ATTreeInst) = unsafe_string(@cxx obj->GetName())
gettitle(obj::ATTreeInst) = unsafe_string(@cxx obj->GetTitle())


bind_branch!(ttree::ATTreeInst, name::AbstractString, value::Ref{T}) where {T<:Union{Number, CppPtr}} = begin
    ttree_obj = auto_deref(ttree)
    icxx"""
        $ttree_obj.SetBranchStatus($name, true);
        $ttree_obj.AddBranchToCache($name, true);
        $ttree_obj.SetBranchAddress($name, &$value);
    """
end

# Workaround for Int64, else ROOT will give this error:
# The pointer type given "Long_t" does not correspond to the type needed "Long64_t"
bind_branch!(ttree::ATTreeInst, name::AbstractString, value::Ref{Int64}) = begin
    ttree_obj = auto_deref(ttree)
    icxx"""
        $ttree_obj.SetBranchStatus($name, true);
        $ttree_obj.AddBranchToCache($name, true);
        $ttree_obj.SetBranchAddress($name, (Long64_t*)&$value);
    """
end

# Workaround for UInt64, else ROOT will give this error:
# The pointer type given "ULong_t" does not correspond to the type needed "ULong64_t"
bind_branch!(ttree::ATTreeInst, name::AbstractString, value::Ref{UInt64}) = begin
    ttree_obj = auto_deref(ttree)
    icxx"""
        $ttree_obj.SetBranchStatus($name, true);
        $ttree_obj.AddBranchToCache($name, true);
        $ttree_obj.SetBranchAddress($name, (ULong64_t*)&$value);
    """
end


create_branch!(ttree::TTreePtr, name::AbstractString, value::Ref{T}; bufsize::Integer = 32000, splitlevel::Integer = 99) where {T<:Union{Number, CppPtr}} =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """

create_branch!(ttree::TTreePtr, name::AbstractString, value::CppValue; bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """
