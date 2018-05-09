# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TObject.h")

import Base: show

export TObject, TObjectPtr, TObjectInst
const TObject = cxxt"TObject"
const TObjectPtr = pcpp"TObject"
const TObjectInst = Union{TObject, TObjectPtr}


tobject_name(x::TObjectInst) = unsafe_string((@cxx x->GetName()))

show(io::IO, x::TObject) =
    print(io, "TObject(\"$(escape_string(tobject_name(x)))\")")

show(io::IO, x::TObjectPtr) =
    print(io, "TObjectPtr(\"$(escape_string(tobject_name(x)))\")")


function dyncast(x::TObjectPtr)
    tstring = icxx"""dynamic_cast<TString*>($x);"""
    !isnullptr(tstring) && return tstring

    tfile = icxx"""dynamic_cast<TFile*>($x);"""
    !isnullptr(tfile) && return tfile

    tdirectory = icxx"""dynamic_cast<TDirectory*>($x);"""
    !isnullptr(tdirectory) && return tdirectory

    tchain = icxx"""dynamic_cast<TChain*>($x);"""
    !isnullptr(tchain) && return tchain

    ttree = icxx"""dynamic_cast<TTree*>($x);"""
    !isnullptr(ttree) && return ttree

    tcanvas = icxx"""dynamic_cast<TCanvas*>($x);"""
    !isnullptr(tcanvas) && return tcanvas

    th1d = icxx"""dynamic_cast<TH1D*>($x);"""
    !isnullptr(th1d) && return th1d
    th1f = icxx"""dynamic_cast<TH1F*>($x);"""
    !isnullptr(th1f) && return th1f
    th1i = icxx"""dynamic_cast<TH1I*>($x);"""
    !isnullptr(th1i) && return th1i

    th2d = icxx"""dynamic_cast<TH2D*>($x);"""
    !isnullptr(th2d) && return th2d
    th2f = icxx"""dynamic_cast<TH2F*>($x);"""
    !isnullptr(th2f) && return th2f
    th2i = icxx"""dynamic_cast<TH2I*>($x);"""
    !isnullptr(th2i) && return th2i

    th3d = icxx"""dynamic_cast<TH3D*>($x);"""
    !isnullptr(th3d) && return th3d
    th3f = icxx"""dynamic_cast<TH3F*>($x);"""
    !isnullptr(th3f) && return th3f
    th3i = icxx"""dynamic_cast<TH3I*>($x);"""
    !isnullptr(th3i) && return th3i
end
