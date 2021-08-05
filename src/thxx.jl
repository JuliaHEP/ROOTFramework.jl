# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TH1D.h")
cxxinclude("TH1F.h")
cxxinclude("TH1I.h")
cxxinclude("TH2D.h")
cxxinclude("TH2F.h")
cxxinclude("TH2I.h")
cxxinclude("TH3D.h")
cxxinclude("TH3F.h")
cxxinclude("TH3I.h")

import Base: show, display, size, push!
import StatsBase: fit

export edge, edges
export getname
export gettitle
export draw


export TH1I, TH1IPtr, TH1IInst, new_TH1I
const TH1I = cxxt"TH1I"
const TH1IPtr = pcpp"TH1I"
const TH1IInst = Union{TH1I, TH1IPtr}

export TH1F, TH1FPtr, TH1FInst, new_TH1F
const TH1F = cxxt"TH1F"
const TH1FPtr = pcpp"TH1F"
const TH1FInst = Union{TH1F, TH1FPtr}

export TH1D, TH1DPtr, TH1DInst, new_TH1D
const TH1D = cxxt"TH1D"
const TH1DPtr = pcpp"TH1D"
const TH1DInst = Union{TH1D, TH1DPtr}

export AnyTH1, AnyTH1Ptr, AnyTH1Inst
const AnyTH1 = Union{TH1I, TH1F, TH1D}
const AnyTH1Ptr = Union{TH1IPtr, TH1FPtr, TH1DPtr}
const AnyTH1Inst = Union{AnyTH1, AnyTH1Ptr}


export TH2I, TH2IPtr, TH2IInst, new_TH2I
const TH2I = cxxt"TH2I"
const TH2IPtr = pcpp"TH2I"
const TH2IInst = Union{TH2I, TH2IPtr}

export TH2F, TH2FPtr, TH2FInst, new_TH2F
const TH2F = cxxt"TH2F"
const TH2FPtr = pcpp"TH2F"
const TH2FInst = Union{TH2F, TH2FPtr}

export TH2D, TH2DPtr, TH2DInst, new_TH2D
const TH2D = cxxt"TH2D"
const TH2DPtr = pcpp"TH2D"
const TH2DInst = Union{TH2D, TH2DPtr}

export AnyTH2, AnyTH2Ptr, AnyTH2Inst
const AnyTH2 = Union{TH2I, TH2F, TH2D}
const AnyTH2Ptr = Union{TH2IPtr, TH2FPtr, TH2DPtr}
const AnyTH2Inst = Union{AnyTH2, AnyTH2Ptr}


export TH3I, TH3IPtr, TH3IInst, new_TH3I
const TH3I = cxxt"TH3I"
const TH3IPtr = pcpp"TH3I"
const TH3IInst = Union{TH3I, TH3IPtr}

export TH3F, TH3FPtr, TH3FInst, new_TH3F
const TH3F = cxxt"TH3F"
const TH3FPtr = pcpp"TH3F"
const TH3FInst = Union{TH3F, TH3FPtr}

export TH3D, TH3DPtr, TH3DInst, new_TH3D
const TH3D = cxxt"TH3D"
const TH3DPtr = pcpp"TH3D"
const TH3DInst = Union{TH3D, TH3DPtr}

export AnyTH3, AnyTH3Ptr, AnyTH3Inst
const AnyTH3 = Union{TH3I, TH3F, TH3D}
const AnyTH3Ptr = Union{TH3IPtr, TH3FPtr, TH3DPtr}
const AnyTH3Inst = Union{AnyTH3, AnyTH3Ptr}


const AnyTH = Union{AnyTH1, AnyTH2, AnyTH3}
const AnyTHPtr = Union{AnyTH1Ptr, AnyTH2Ptr, AnyTH3Ptr}
const AnyTHInst = Union{AnyTH1Inst, AnyTH2Inst, AnyTH3Inst}

export THxx, new_THxx


init_thxx(hist::AnyTHInst, edges::NTuple{N,AbstractRange}) where N = begin
    @cxx hist->SetBins(axis_spec(edges)...)
    hist
end

init_thxx(hist::AnyTHInst, edges::NTuple{N, AbstractRange}, name::AbstractString, title::AbstractString) where N = begin
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


THxx(::Type{Int32}, edges::NTuple{1, AbstractRange}, args...) = init_thxx((@cxx TH1I()), edges, args...)
new_THxx(::Type{Int32}, edges::NTuple{1, AbstractRange}, args...) = init_thxx(icxx""" new TH1I; """, edges, args...)

THxx(::Type{Float32}, edges::NTuple{1, AbstractRange}, args...) = init_thxx((@cxx TH1F()), edges, args...)
new_THxx(::Type{Float32}, edges::NTuple{1, AbstractRange}, args...) = init_thxx(icxx""" new TH1F; """, edges, args...)

THxx(::Type{Float64}, edges::NTuple{1, AbstractRange}, args...) = init_thxx((@cxx TH1D()), edges, args...)
new_THxx(::Type{Float64}, edges::NTuple{1, AbstractRange}, args...) = init_thxx(icxx""" new TH1D; """, edges, args...)

THxx(::Type{T}, edge::AbstractRange, args...) where {T<:Real} = THxx(T, (edge,), args...)
new_THxx(::Type{T}, edge::AbstractRange, args...) where {T<:Real} = new_THxx(T, (edge,), args...)


THxx(::Type{Int32}, edges::NTuple{2, AbstractRange}, args...) = init_thxx((@cxx TH2I()), edges, args...)
new_THxx(::Type{Int32}, edges::NTuple{2, AbstractRange}, args...) = init_thxx(icxx""" new TH2I; """, edges, args...)

THxx(::Type{Float32}, edges::NTuple{2, AbstractRange}, args...) = init_thxx((@cxx TH2F()), edges, args...)
new_THxx(::Type{Float32}, edges::NTuple{2, AbstractRange}, args...) = init_thxx(icxx""" new TH2F; """, edges, args...)

THxx(::Type{Float64}, edges::NTuple{2, AbstractRange}, args...) = init_thxx((@cxx TH2D()), edges, args...)
new_THxx(::Type{Float64}, edges::NTuple{2, AbstractRange}, args...) = init_thxx(icxx""" new TH2D; """, edges, args...)


THxx(::Type{Int32}, edges::NTuple{3, AbstractRange}, args...) = init_thxx((@cxx TH3I()), edges, args...)
new_THxx(::Type{Int32}, edges::NTuple{3, AbstractRange}, args...) = init_thxx(icxx""" new TH3I; """, edges, args...)

THxx(::Type{Float32}, edges::NTuple{3, AbstractRange}, args...) = init_thxx((@cxx TH3F()), edges, args...)
new_THxx(::Type{Float32}, edges::NTuple{3, AbstractRange}, args...) = init_thxx(icxx""" new TH3F; """, edges, args...)

THxx(::Type{Float64}, edges::NTuple{3, AbstractRange}, args...) = init_thxx((@cxx TH3D()), edges, args...)
new_THxx(::Type{Float64}, edges::NTuple{3, AbstractRange}, args...) = init_thxx(icxx""" new TH3D; """, edges, args...)


THxx(edges::NTuple{N, AbstractRange}, args...) where N = THxx(Float64, edges, args...)
new_THxx(edges::NTuple{N, AbstractRange}, args...) where N = new_THxx(Float64, edges, args...)

THxx(edge::AbstractRange, args...) = THxx(Float64, (edge, ), args...)
new_THxx(edge::AbstractRange, args...) = new_THxx(Float64, (edge, ), args...)


show(io::IO, hist::AnyTH) = begin
    tpname = string(typeof(hist).parameters[1].parameters[1].parameters[1])
    print(io, "$tpname($(size(hist)), \"$(escape_string(getname(hist)))\", \"$(escape_string(gettitle(hist)))\")")
end

getname(obj::AnyTHInst) = unsafe_string(@cxx obj->GetName())

gettitle(obj::AnyTHInst) = unsafe_string(@cxx obj->GetTitle())

push!(hist::AnyTH1Inst, x::T) where {T <: Union{Integer, AbstractFloat}} = @cxx hist->Fill(x)
push!(hist::AnyTH1Inst, x::NTuple{1, T}) where {T <: Union{Integer, AbstractFloat}} = @cxx hist->Fill(x[1])
push!(hist::AnyTH2Inst, x::NTuple{2, T}) where {T <: Union{Integer, AbstractFloat}} = @cxx hist->Fill(x[1], x[2])
push!(hist::AnyTH3Inst, x::NTuple{3, T}) where {T <: Union{Integer, AbstractFloat}} = @cxx hist->Fill(x[1], x[2], x[3])

draw(hist::AnyTHInst) = @cxx hist->Draw()
draw(hist::AnyTHInst, option) = @cxx hist->Draw(pointer(option))


fit(hist::AnyTHInst, f::AbstractString) = @cxx hist->Fit(pointer(f))
