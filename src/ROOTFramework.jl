# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

__precompile__(false)

module ROOTFramework

using ROOT

include("pointers.jl")
include("tstring.jl")
include("gui.jl")
include("tcanvas.jl")
include("tbrowser.jl")
include("tcolor.jl")
include("json.jl")
include("taxis.jl")
include("tdirectory.jl")
include("tfitresult.jl")
include("thxx.jl")
include("ttree.jl")
include("ttree_bindings.jl")

end # module
