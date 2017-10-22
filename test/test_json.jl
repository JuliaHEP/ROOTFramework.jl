# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using ROOTFramework

using Compat.Test

import JSON


@testset "TTree I/O" begin
    hist = TH1D()
    JSON.parse(rootjson(hist))
end
