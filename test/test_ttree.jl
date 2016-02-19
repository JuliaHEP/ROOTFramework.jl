# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using ROOTFramework

import EasyPkg
@EasyPkg.using_BaseTest


@testset "TTree I/O" begin
    const scratchdir = mktempdir()
    try
        fname = joinpath(scratchdir, "out.root")

        tfile = TFile(fname, "recreate")
        ttree = create_ttree(tfile, "data", "Data")

        idx = Ref{Int32}(0)
        v = Ref(0.0)

        create_branch(ttree, "idx", idx)
        create_branch(ttree, "v", v)

        for i in 1:1000000
            idx.x = i
            v.x = rand()
            fill(ttree)
        end

        close(tfile)
    finally
        rm(scratchdir; recursive = true)
    end
end
