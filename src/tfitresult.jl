# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TFitResultPtr.h")

import Base: show


const TFitResultPtr = cxxt"TFitResultPtr"


function show(io::IO, x::TFitResultPtr)
    print(io, "TFitResultPtr(")
    show(io, reinterpret(Culong, @cxx x->Get()))
    print(io, ")")
end
