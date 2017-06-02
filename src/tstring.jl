# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TString.h")

import Base: string, show

export TString, TStringPtr
const TString = cxxt"TString"
const TStringPtr = pcpp"TString"


TString() = @cxx TString()
TString(str::AbstractString) = @cxx TString(pointer(str))

string(tstr::TString) = unsafe_string((@cxx tstr->Data()), (@cxx tstr->Length()))
show(io::IO, x::TString) = print(io, "TString(\"$(escape_string(string(x)))\")")
