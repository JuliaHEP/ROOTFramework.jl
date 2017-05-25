# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

__precompile__(false)

module ROOTFramework

using ROOT

include.([
    "pointers.jl",
    "tstring.jl",
    "gui.jl",
    "tcanvas.jl",
    "tbrowser.jl",
    "tcolor.jl",
    "json.jl",
    "taxis.jl",
    "tdirectory.jl",
    "tfitresult.jl",
    "thxx.jl",
    "ttree.jl",
    "ttree_bindings.jl",
])

end # module
