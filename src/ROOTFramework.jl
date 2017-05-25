# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

__precompile__(false)

module ROOTFramework

using Cxx
import CxxStd


export cxx_tmpl_arg_tp
cxx_tmpl_arg_tp(t) = t <: Cxx.CppValue ? t.parameters[1] : t

export Std_String
typealias Std_String cxxt"std::string"

export Std_Vector
typealias Std_Vector{T} cxxt"std::vector<$(cxx_tmpl_arg_tp(T))>"


function module__init__()
    incdir = strip(readstring(`root-config --incdir`))
    libdir = strip(readstring(`root-config --libdir`))

    addHeaderDir(incdir, kind=C_System)

    Libdl.dlopen(joinpath(libdir, "libGui.so"), Libdl.RTLD_GLOBAL)
    Libdl.dlopen(joinpath(libdir, "libHist.so"), Libdl.RTLD_GLOBAL)
    Libdl.dlopen(joinpath(libdir, "libTree.so"), Libdl.RTLD_GLOBAL)
    Libdl.dlopen(joinpath(libdir, "libRHTTP.so"), Libdl.RTLD_GLOBAL)
end

module__init__()


# Enable thread-safety for ROOT:
cxxinclude("TThread.h")
icxx"TThread::Initialize();"


include.([
    "tvirtualmutex.jl",
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
