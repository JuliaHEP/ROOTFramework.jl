# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

# __precompile__()

module ROOTFramework

using Compat
using Cxx
import CxxStd


export cxx_tmpl_arg_tp
cxx_tmpl_arg_tp(t) = t <: Cxx.CppValue ? t.parameters[1] : t

export Std_String
typealias Std_String cxxt"std::string"

export Std_Vector
typealias Std_Vector{T} cxxt"std::vector<$(cxx_tmpl_arg_tp(T))>"


function module__init__()
    incdir = strip(@compat readstring(`root-config --incdir`))
    libdir = strip(@compat readstring(`root-config --libdir`))

    addHeaderDir(incdir, kind=C_System)

    Libdl.dlopen(joinpath(libdir, "libGui.so"), Libdl.RTLD_GLOBAL)
    Libdl.dlopen(joinpath(libdir, "libHist.so"), Libdl.RTLD_GLOBAL)
    Libdl.dlopen(joinpath(libdir, "libTree.so"), Libdl.RTLD_GLOBAL)
    Libdl.dlopen(joinpath(libdir, "libRHTTP.so"), Libdl.RTLD_GLOBAL)

    cxxinclude("TApplication.h")
    cxxinclude("TBrowser.h")
    cxxinclude("TBufferJSON.h")
    cxxinclude("TChain.h")
    cxxinclude("TFile.h")
    cxxinclude("TFitResultPtr.h")
    cxxinclude("TH1D.h")
    cxxinclude("TH1F.h")
    cxxinclude("TH1I.h")
    cxxinclude("TH2D.h")
    cxxinclude("TH2F.h")
    cxxinclude("TH2I.h")
    cxxinclude("TString.h")
    cxxinclude("TSystem.h")
    cxxinclude("TTree.h")
end

module__init__()



export TBrowserPtr
typealias TBrowserPtr pcpp"TBrowser"


export TDirectoryRef, TDirectoryPtr, TDirectoryInst
typealias TDirectoryRef rcpp"TDirectory"
typealias TDirectoryPtr pcpp"TDirectory"
const TDirectoryInst = Union{TDirectoryRef, TDirectoryPtr}

export TFile, TFilePtr, TFileInst
typealias TFile cxxt"TFile"
typealias TFilePtr pcpp"TFile"
const TFileInst = Union{TFile, TFilePtr}

export ATDirectoryInst
const ATDirectoryInst = Union{TDirectoryInst, TFileInst}

typealias TFitResultPtr cxxt"TFitResultPtr"


export TH1I, TH1IPtr, TH1IInst, new_TH1I
typealias TH1I cxxt"TH1I"
typealias TH1IPtr pcpp"TH1I"
const TH1IInst = Union{TH1I, TH1IPtr}

export TH1F, TH1FPtr, TH1FInst, new_TH1F
typealias TH1F cxxt"TH1F"
typealias TH1FPtr pcpp"TH1F"
const TH1FInst = Union{TH1F, TH1FPtr}

export TH1D, TH1DPtr, TH1DInst, new_TH1D
typealias TH1D cxxt"TH1D"
typealias TH1DPtr pcpp"TH1D"
const TH1DInst = Union{TH1D, TH1DPtr}

export ATH1, ATH1Ptr, ATH1Inst
ATH1 = Union{TH1I, TH1F, TH1D}
ATH1Ptr = Union{TH1IPtr, TH1FPtr, TH1DPtr}
ATH1Inst = Union{ATH1, ATH1Ptr}


export TH2I, TH2IPtr, TH2IInst, new_TH2I
typealias TH2I cxxt"TH2I"
typealias TH2IPtr pcpp"TH2I"
const TH2IInst = Union{TH2I, TH2IPtr}

export TH2F, TH2FPtr, TH2FInst, new_TH2F
typealias TH2F cxxt"TH2F"
typealias TH2FPtr pcpp"TH2F"
const TH2FInst = Union{TH2F, TH2FPtr}

export TH2D, TH2DPtr, TH2DInst, new_TH2D
typealias TH2D cxxt"TH2D"
typealias TH2DPtr pcpp"TH2D"
const TH2DInst = Union{TH2D, TH2DPtr}

export ATH2, ATH2Ptr, ATH2Inst
ATH2 = Union{TH2I, TH2F, TH2D}
ATH2Ptr = Union{TH2IPtr, TH2FPtr, TH2DPtr}
ATH2Inst = Union{ATH2, ATH2Ptr}


export TString, TStringPtr
typealias TString cxxt"TString"
typealias TStringPtr pcpp"TString"


export TTreePtr
typealias TTreePtr pcpp"TTree"

export TChain, TChainPtr
typealias TChain cxxt"TChain"
typealias TChainPtr pcpp"TChain"

export ATTreeInst
const ATTreeInst = Union{TTreePtr, TChain}


import EasyPkg
EasyPkg.include_all_sources()

end # module
