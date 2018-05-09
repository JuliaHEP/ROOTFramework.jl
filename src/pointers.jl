# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: pointer

export isnullptr
export delete_if_not_nullptr

pointer_to(x::Union{Cxx.CppValue, Cxx.CppRef}) =
    icxx""" &$x; """

as_pointer(x::Cxx.CppPtr) = x
as_pointer(x::Union{Cxx.CppValue, Cxx.CppRef}) = pointer_to(x)

isnullptr(ptr::Cxx.CppPtr) = Ptr{Void}(ptr) == Ptr{Void}(0)

delete_if_not_nullptr(ptr::Cxx.CppPtr) = begin
    if ! isnullptr(ptr)
        icxx""" delete $ptr; """
    end
end

auto_deref(v::Cxx.CppPtr) = icxx"*$(v);"::Cxx.CppRef
auto_deref(v::Cxx.CppValue) = v
auto_deref(v::Cxx.CppRef) = v
