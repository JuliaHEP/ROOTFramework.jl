# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TAxis.h")


export TAxisPtr
const TAxisPtr = pcpp"TAxis"


axis_spec(edge::AbstractRange{<:Real}) = begin
    nbins = length(edge) - 1
    (nbins < 1) && error("Number of bins must be at least 1")
    (nbins, Float64(first(edge)), Float64((last(edge))))
end

axis_spec(edges::NTuple{1,AbstractRange{<:Real}}) = (axis_spec(edges[1])...,)
axis_spec(edges::NTuple{2,AbstractRange{<:Real}}) = (axis_spec(edges[1])..., axis_spec(edges[2])...)
axis_spec(edges::NTuple{3,AbstractRange{<:Real}}) = (axis_spec(edges[1])..., axis_spec(edges[2])..., axis_spec(edges[3])...)

axis_AbstractRange(nbins, low, up) = low:((up - low) / nbins):up

Base.AbstractRange{<:Real}(axis::TAxisPtr) = axis_AbstractRange((@cxx axis->GetNbins()), (@cxx axis->GetXmin()), (@cxx axis->GetXmax()))
