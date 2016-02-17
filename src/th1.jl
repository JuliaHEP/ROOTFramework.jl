# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: show, display, fill!
import StatsBase: fit

export getname
export gettitle
export getnbins
export draw


TH1I() = @cxx TH1I()
TH1I(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) =
    init_th1(TH1I(), name, title, nbinsx, xlow, xup)

new_TH1I() = icxx""" new TH1I; """
new_TH1I(hist::TH1IInst) = icxx""" new TH1I($hist); """
new_TH1I(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) =
    init_th1(new_TH1I(), name, title, nbinsx, xlow, xup)


TH1F() = @cxx TH1F()
TH1F(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) =
    init_th1(TH1F(), name, title, nbinsx, xlow, xup)

new_TH1F() = icxx""" new TH1F; """
new_TH1F(hist::TH1FInst) = icxx""" new TH1F($hist); """
new_TH1F(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) =
    init_th1(new_TH1F(), name, title, nbinsx, xlow, xup)


TH1D() = @cxx TH1D()
TH1D(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) =
    init_th1(TH1D(), name, title, nbinsx, xlow, xup)

new_TH1D() = icxx""" new TH1D; """
new_TH1D(hist::TH1DInst) = icxx""" new TH1D($hist); """
new_TH1D(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) =
    init_th1(new_TH1D(), name, title, nbinsx, xlow, xup)


init_th1(hist::ATH1Inst, name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real) = begin
    @cxx hist->SetNameTitle(pointer(name), pointer(title))
    @cxx hist->SetBins(nbinsx, xlow, xup)
    hist
end

show(io::IO, hist::ATH1) = begin
    tpname = string(typeof(hist).parameters[1].parameters[1].parameters[1])
    print(io, "$tpname(\"$(escape_string(getname(hist)))\", \"$(escape_string(gettitle(hist)))\", $(getnbins(hist)))")
end

getname(obj::ATH1Inst) = bytestring(@cxx obj->GetName())

gettitle(obj::ATH1Inst) = bytestring(@cxx obj->GetTitle())

getnbins(hist::ATH1Inst) = @cxx hist->GetNbinsX()

fill!(hist::ATH1Inst, x::Integer) = @cxx hist->Fill(x)
fill!(hist::ATH1Inst, x::AbstractFloat) = @cxx hist->Fill(x)

draw(hist::ATH1Inst) = @cxx hist->Draw()
fit(hist::ATH1Inst, f::AbstractString) = @cxx hist->Fit(pointer(f))
