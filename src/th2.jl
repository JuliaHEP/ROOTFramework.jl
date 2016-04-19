# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: show, display, push!
import StatsBase: fit

export getname
export gettitle
export getnbins
export draw


TH2I() = @cxx TH2I()
TH2I(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) =
    init_th1(TH2I(), name, title, nbinsx, xlow, xup, nbinsy, ylow, yup)

new_TH2I() = icxx""" new TH2I; """
new_TH2I(hist::TH2IInst) = icxx""" new TH2I($hist); """
new_TH2I(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) =
    init_th1(new_TH2I(), name, title, nbinsx, xlow, xup, nbinsy, ylow, yup)


TH2F() = @cxx TH2F()
TH2F(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) =
    init_th1(TH2F(), name, title, nbinsx, xlow, xup, nbinsy, ylow, yup)

new_TH2F() = icxx""" new TH2F; """
new_TH2F(hist::TH2FInst) = icxx""" new TH2F($hist); """
new_TH2F(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) =
    init_th1(new_TH2F(), name, title, nbinsx, xlow, xup, nbinsy, ylow, yup)


TH2D() = @cxx TH2D()
TH2D(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) =
    init_th1(TH2D(), name, title, nbinsx, xlow, xup, nbinsy, ylow, yup)

new_TH2D() = icxx""" new TH2D; """
new_TH2D(hist::TH2DInst) = icxx""" new TH2D($hist); """
new_TH2D(name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) =
    init_th1(new_TH2D(), name, title, nbinsx, xlow, xup, nbinsy, ylow, yup)


init_th1(hist::ATH2Inst, name::AbstractString, title::AbstractString, nbinsx::Integer, xlow::Real, xup::Real, nbinsy::Integer, ylow::Real, yup::Real) = begin
    @cxx hist->SetNameTitle(pointer(name), pointer(title))
    @cxx hist->SetBins(nbinsx, xlow, xup, nbinsy, ylow, yup)
    hist
end

show(io::IO, hist::ATH2) = begin
    tpname = string(typeof(hist).parameters[1].parameters[1].parameters[1])
    print(io, "$tpname(\"$(escape_string(getname(hist)))\", \"$(escape_string(gettitle(hist)))\", $(getnbins(hist)))")
end

getname(obj::ATH2Inst) = bytestring(@cxx obj->GetName())

gettitle(obj::ATH2Inst) = bytestring(@cxx obj->GetTitle())

getnbins(hist::ATH2Inst) = @cxx hist->GetNbinsX()

push!{T <: Union{Integer, AbstractFloat}}(hist::ATH2Inst, x::NTuple{2, T}) = @cxx hist->Fill(x[1], x[2])

draw(hist::ATH2Inst) = @cxx hist->Draw()
draw(hist::ATH2Inst, option) = @cxx hist->Draw(pointer(option))

# fit(hist::ATH2Inst, f::AbstractString) = @cxx hist->Fit(pointer(f))
