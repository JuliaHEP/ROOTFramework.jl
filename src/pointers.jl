# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: pointer

export isnullptr
export delete_if_not_nullptr

pointer(x::Union{Cxx.CppValue, Cxx.CppRef}) =
    icxx""" &$x; """

isnullptr(ptr::Cxx.CppPtr) = ptr.ptr == Ptr{Void}(0)

delete_if_not_nullptr(ptr::Cxx.CppPtr) = begin
    if ! isnullptr(ptr)
        icxx""" delete $ptr; """
    end
end
