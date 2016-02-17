# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using ROOTFramework

import EasyPkg
@EasyPkg.using_BaseTest

import JSON


@testset "TTree I/O" begin
    hist = TH1D()
    JSON.parse(rootjson(hist))
end
