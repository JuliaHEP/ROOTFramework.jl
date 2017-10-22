# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

import Compat.Test
Test.@testset "Package ROOTFramework" begin
    include("test_json.jl")
    include("test_ttree.jl")
end
