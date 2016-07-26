# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: show, display, size, push!
import StatsBase: fit

export edge, edges
export getname
export gettitle
export draw


init_thxx{N}(hist::AnyTHInst, edges::NTuple{N, Range}) = begin
    @cxx hist->SetBins(axis_spec(edges)...)
    hist
end

init_thxx{N}(hist::AnyTHInst, edges::NTuple{N, Range}, name::AbstractString, title::AbstractString) = begin
    init_thxx(hist, edges)
    @cxx hist->SetNameTitle(pointer(name), pointer(title))
    hist
end


size(hist::AnyTH1Inst) = ((@cxx hist->GetNbinsX()),)
size(hist::AnyTH2Inst) = ((@cxx hist->GetNbinsX()), (@cxx hist->GetNbinsY()))
size(hist::AnyTH3Inst) = ((@cxx hist->GetNbinsX()), (@cxx hist->GetNbinsY()), (@cxx hist->GetNbinsZ()))

xaxis(hist::AnyTHInst) = @cxx hist->GetXaxis()
yaxis(hist::Union{AnyTH2Inst, AnyTH3Inst}) = @cxx hist->GetYaxis()
zaxis(hist::AnyTH3Inst) = @cxx hist->GetZaxis()

edge(hist::AnyTH1Inst) = range(xaxis(hist))

edges(hist::AnyTH1Inst) = (range(xaxis(hist)),)
edges(hist::AnyTH2Inst) = range(xaxis(hist)), range(yaxis(hist))
edges(hist::AnyTH3Inst) = (range(xaxis(hist)), range(yaxis(hist)), range(zaxis(hist)))


THxx(::Type{Int32}, edges::NTuple{1, Range}, args...) = init_thxx((@cxx TH1I()), edges, args...)
new_THxx(::Type{Int32}, edges::NTuple{1, Range}, args...) = init_thxx(icxx""" new TH1I; """, edges, args...)

THxx(::Type{Float32}, edges::NTuple{1, Range}, args...) = init_thxx((@cxx TH1F()), edges, args...)
new_THxx(::Type{Float32}, edges::NTuple{1, Range}, args...) = init_thxx(icxx""" new TH1F; """, edges, args...)

THxx(::Type{Float64}, edges::NTuple{1, Range}, args...) = init_thxx((@cxx TH1D()), edges, args...)
new_THxx(::Type{Float64}, edges::NTuple{1, Range}, args...) = init_thxx(icxx""" new TH1D; """, edges, args...)

THxx{T}(::Type{T}, edge::Range, args...) = THxx(T, (edge,), args...)
new_THxx{T}(::Type{T}, edge::Range, args...) = new_THxx(T, (edge,), args...)


THxx(::Type{Int32}, edges::NTuple{2, Range}, args...) = init_thxx((@cxx TH2I()), edges, args...)
new_THxx(::Type{Int32}, edges::NTuple{2, Range}, args...) = init_thxx(icxx""" new TH2I; """, edges, args...)

THxx(::Type{Float32}, edges::NTuple{2, Range}, args...) = init_thxx((@cxx TH2F()), edges, args...)
new_THxx(::Type{Float32}, edges::NTuple{2, Range}, args...) = init_thxx(icxx""" new TH2F; """, edges, args...)

THxx(::Type{Float64}, edges::NTuple{2, Range}, args...) = init_thxx((@cxx TH2D()), edges, args...)
new_THxx(::Type{Float64}, edges::NTuple{2, Range}, args...) = init_thxx(icxx""" new TH2D; """, edges, args...)


THxx(::Type{Int32}, edges::NTuple{3, Range}, args...) = init_thxx((@cxx TH3I()), edges, args...)
new_THxx(::Type{Int32}, edges::NTuple{3, Range}, args...) = init_thxx(icxx""" new TH3I; """, edges, args...)

THxx(::Type{Float32}, edges::NTuple{3, Range}, args...) = init_thxx((@cxx TH3F()), edges, args...)
new_THxx(::Type{Float32}, edges::NTuple{3, Range}, args...) = init_thxx(icxx""" new TH3F; """, edges, args...)

THxx(::Type{Float64}, edges::NTuple{3, Range}, args...) = init_thxx((@cxx TH3D()), edges, args...)
new_THxx(::Type{Float64}, edges::NTuple{3, Range}, args...) = init_thxx(icxx""" new TH3D; """, edges, args...)


THxx{N}(edges::NTuple{N, Range}, args...) = THxx(Float64, edges, args...)
new_THxx{N}(edges::NTuple{N, Range}, args...) = new_THxx(Float64, edges, args...)

THxx(edge::Range, args...) = THxx(Float64, (edge, ), args...)
new_THxx(edge::Range, args...) = new_THxx(Float64, (edge, ), args...)


show(io::IO, hist::AnyTH) = begin
    tpname = string(typeof(hist).parameters[1].parameters[1].parameters[1])
    print(io, "$tpname($(size(hist)), \"$(escape_string(getname(hist)))\", \"$(escape_string(gettitle(hist)))\")")
end

getname(obj::AnyTHInst) = unsafe_string(@cxx obj->GetName())

gettitle(obj::AnyTHInst) = unsafe_string(@cxx obj->GetTitle())

push!{T <: Union{Integer, AbstractFloat}}(hist::AnyTH1Inst, x::T) = @cxx hist->Fill(x)
push!{T <: Union{Integer, AbstractFloat}}(hist::AnyTH1Inst, x::NTuple{1, T}) = @cxx hist->Fill(x[1])
push!{T <: Union{Integer, AbstractFloat}}(hist::AnyTH2Inst, x::NTuple{2, T}) = @cxx hist->Fill(x[1], x[2])
push!{T <: Union{Integer, AbstractFloat}}(hist::AnyTH3Inst, x::NTuple{3, T}) = @cxx hist->Fill(x[1], x[2], x[3])

draw(hist::AnyTHInst) = @cxx hist->Draw()
draw(hist::AnyTHInst, option) = @cxx hist->Draw(pointer(option))


fit(hist::AnyTHInst, f::AbstractString) = @cxx hist->Fit(pointer(f))
