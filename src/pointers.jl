# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

pointer_to(x::Union{CppValue, CppRef}) =
    icxx""" &$x; """

as_pointer(x::CppPtr) = x
as_pointer(x::Union{CppValue, CppRef}) = pointer_to(x)

isnullptr(ptr::CppPtr) = Ptr{Void}(ptr) == Ptr{Void}(0)

delete_if_not_nullptr(ptr::CppPtr) = begin
    if ! isnullptr(ptr)
        icxx""" delete $ptr; """
    end
end

auto_deref(v::CppPtr) = icxx"*$(v);"::CppRef
auto_deref(v::CppValue) = v
auto_deref(v::CppRef) = v
