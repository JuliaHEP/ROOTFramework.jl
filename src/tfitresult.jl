# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TFitResultPtr.h")

import Base: show


const TFitResultPtr = cxxt"TFitResultPtr"


show(io::IO, x::TFitResultPtr) = print(io, "TFitResultPtr($(convert(UInt, (@cxx x->Get()).ptr)))")
