# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: string, show


TString() = @cxx TString()
TString(str::AbstractString) = @cxx TString(pointer(str))

string(tstr::TString) = bytestring((@cxx tstr->Data()), (@cxx tstr->Length()))
show(io::IO, x::TString) = print(io, "TString(\"$(escape_string(string(x)))\")")
