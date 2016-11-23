# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

__precompile__(false)

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
    cxxinclude("TCanvas.h")
    cxxinclude("TChain.h")
    cxxinclude("TColor.h")
    cxxinclude("TFile.h")
    cxxinclude("TFitResultPtr.h")
    cxxinclude("TH1D.h")
    cxxinclude("TH1F.h")
    cxxinclude("TH1I.h")
    cxxinclude("TH2D.h")
    cxxinclude("TH2F.h")
    cxxinclude("TH2I.h")
    cxxinclude("TH3D.h")
    cxxinclude("TH3F.h")
    cxxinclude("TH3I.h")
    cxxinclude("TString.h")
    cxxinclude("TStyle.h")
    cxxinclude("TSystem.h")
    cxxinclude("TTree.h")
end

module__init__()



export TBrowserPtr
typealias TBrowserPtr pcpp"TBrowser"


export TDirectoryRef, TDirectoryPtr, TDirectoryInst
typealias TDirectoryRef rcpp"TDirectory"
typealias TDirectoryPtr pcpp"TDirectory"
typealias TDirectoryInst Union{TDirectoryRef, TDirectoryPtr}

export TFile, TFilePtr, TFileInst
typealias TFile cxxt"TFile"
typealias TFilePtr pcpp"TFile"
typealias TFileInst Union{TFile, TFilePtr}

export ATDirectoryInst
typealias ATDirectoryInst Union{TDirectoryInst, TFileInst}

typealias TFitResultPtr cxxt"TFitResultPtr"


export TAxisPtr
typealias TAxisPtr pcpp"TAxis"


export TH1I, TH1IPtr, TH1IInst, new_TH1I
typealias TH1I cxxt"TH1I"
typealias TH1IPtr pcpp"TH1I"
typealias TH1IInst Union{TH1I, TH1IPtr}

export TH1F, TH1FPtr, TH1FInst, new_TH1F
typealias TH1F cxxt"TH1F"
typealias TH1FPtr pcpp"TH1F"
typealias TH1FInst Union{TH1F, TH1FPtr}

export TH1D, TH1DPtr, TH1DInst, new_TH1D
typealias TH1D cxxt"TH1D"
typealias TH1DPtr pcpp"TH1D"
typealias TH1DInst Union{TH1D, TH1DPtr}

export AnyTH1, AnyTH1Ptr, AnyTH1Inst
typealias AnyTH1 Union{TH1I, TH1F, TH1D}
typealias AnyTH1Ptr Union{TH1IPtr, TH1FPtr, TH1DPtr}
typealias AnyTH1Inst Union{AnyTH1, AnyTH1Ptr}


export TH2I, TH2IPtr, TH2IInst, new_TH2I
typealias TH2I cxxt"TH2I"
typealias TH2IPtr pcpp"TH2I"
typealias TH2IInst Union{TH2I, TH2IPtr}

export TH2F, TH2FPtr, TH2FInst, new_TH2F
typealias TH2F cxxt"TH2F"
typealias TH2FPtr pcpp"TH2F"
typealias TH2FInst Union{TH2F, TH2FPtr}

export TH2D, TH2DPtr, TH2DInst, new_TH2D
typealias TH2D cxxt"TH2D"
typealias TH2DPtr pcpp"TH2D"
typealias TH2DInst Union{TH2D, TH2DPtr}

export AnyTH2, AnyTH2Ptr, AnyTH2Inst
typealias AnyTH2 Union{TH2I, TH2F, TH2D}
typealias AnyTH2Ptr Union{TH2IPtr, TH2FPtr, TH2DPtr}
typealias AnyTH2Inst Union{AnyTH2, AnyTH2Ptr}


export TH3I, TH3IPtr, TH3IInst, new_TH3I
typealias TH3I cxxt"TH3I"
typealias TH3IPtr pcpp"TH3I"
typealias TH3IInst Union{TH3I, TH3IPtr}

export TH3F, TH3FPtr, TH3FInst, new_TH3F
typealias TH3F cxxt"TH3F"
typealias TH3FPtr pcpp"TH3F"
typealias TH3FInst Union{TH3F, TH3FPtr}

export TH3D, TH3DPtr, TH3DInst, new_TH3D
typealias TH3D cxxt"TH3D"
typealias TH3DPtr pcpp"TH3D"
typealias TH3DInst Union{TH3D, TH3DPtr}

export AnyTH3, AnyTH3Ptr, AnyTH3Inst
typealias AnyTH3 Union{TH3I, TH3F, TH3D}
typealias AnyTH3Ptr Union{TH3IPtr, TH3FPtr, TH3DPtr}
typealias AnyTH3Inst Union{AnyTH3, AnyTH3Ptr}


typealias AnyTH Union{AnyTH1, AnyTH2, AnyTH3}
typealias AnyTHPtr Union{AnyTH1Ptr, AnyTH2Ptr, AnyTH3Ptr}
typealias AnyTHInst Union{AnyTH1Inst, AnyTH2Inst, AnyTH3Inst}

export THxx, new_THxx


export TString, TStringPtr
typealias TString cxxt"TString"
typealias TStringPtr pcpp"TString"


export TTreePtr
typealias TTreePtr pcpp"TTree"

export TChain, TChainPtr, TChainInst
typealias TChain cxxt"TChain"
typealias TChainPtr pcpp"TChain"
typealias TChainInst Union{TChain, TChainPtr}

export ATTreeInst
typealias ATTreeInst Union{TTreePtr, TChainInst}


import EasyPkg
EasyPkg.include_all_sources()

end # module
