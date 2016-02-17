# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: show, fill


export create_ttree
export create_branch
export getname
export gettitle
export connect_branch



create_ttree(tdir::ATDirectoryInst, name::AbstractString, title::AbstractString) =
    @tmp_tdir_cd tdir icxx""" new TTree($name, $title); """

create_branch{T<:Number}(ttree::TTreePtr, name::AbstractString, value::Ref{T}, bufsize::Integer = 32000, splitlevel::Integer = 99) =
    icxx""" $ttree->Branch($name, &$value, $(Int32(bufsize)), $(Int32(splitlevel))); """

fill(ttree::TTreePtr) = icxx""" $ttree->Fill(); """



show(io::IO, x::TChain) = print(io, "TChain(\"$(escape_string(getname(x)))\")")


getname(obj::ATTreeInst) = bytestring(@cxx obj->GetName())

gettitle(obj::ATTreeInst) = bytestring(@cxx obj->GetTitle())

connect_branch{T<:Number}(ttree::ATTreeInst, name::AbstractString, value::Ref{T}) =
    icxx""" $ttree->SetBranchAddress($name, &$value); """
