# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

__precompile__(false)

module ROOTFramework

using Cxx
using ROOT

using Cxx.CxxCore: CppValue, CppPtr, CppRef, CxxBuiltinTs

macro rcpp_str(s,args...)
    CppRef{Cxx.CxxCore.simpleCppType(s),Cxx.CxxCore.NullCVR}
end

include("pointers.jl")
include("tstring.jl")
include("tobject.jl")
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
