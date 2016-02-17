# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: show


show(io::IO, x::TFitResultPtr) = print(io, "TFitResultPtr($(convert(UInt, (@cxx x->Get()).ptr)))")
