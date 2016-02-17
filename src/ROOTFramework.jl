# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

# __precompile__()

module ROOTFramework

using Compat
using Cxx

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
