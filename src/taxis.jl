# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: range


axis_spec(edge::Range) = begin
    nbins = length(edge) - 1
    (nbins < 1) && error("Number of bins must be at least 1")
    (nbins, Float64(first(edge)), Float64((last(edge))))
end

axis_spec(edges::NTuple{1, Range}) = (axis_spec(edges[1])...)
axis_spec(edges::NTuple{2, Range}) = (axis_spec(edges[1])..., axis_spec(edges[2])...)
axis_spec(edges::NTuple{3, Range}) = (axis_spec(edges[1])..., axis_spec(edges[2])..., axis_spec(edges[3])...)

axis_range(nbins, low, up) = low:((up - low) / nbins):up

range(axis::TAxisPtr) = axis_range((@cxx axis->GetNbins()), (@cxx axis->GetXmin()), (@cxx axis->GetXmax()))
