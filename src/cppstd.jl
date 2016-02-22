# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).


module CppStd

using Cxx
import CxxStd

import Base: Vector
import Base: convert, copy!, resize!, show

export CppVector, CppVectorRef, CppVectorPtr
export cpp_vector, array_view


typealias CppVector{T} cxxt"std::vector<$T>"
typealias CppVectorRef{T} cxxt"std::vector<$T>&"
typealias CppVectorPtr{T} Cxx.CppPtr{Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{symbol("std::vector")},Tuple{T,Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{symbol("std::allocator")},Tuple{T}},(false,false,false)}}},(false,false,false)},(false,false,false)}


cpp_vector{T}(::Type{T}) =
    icxx""" std::vector<$T>(); """

cpp_vector{T}(::Type{T}, n::Integer) = begin
    v = cpp_vector(T)
    resize!(v, n)
end


convert{T}(::Type{Vector{T}}, x::Union{CppVector, CppVectorRef, CppVectorPtr}) = begin
    y = Array(Int, @cxx x->size())
    copy!(y, x)
    y
end


copy!(dest::Vector, src::Union{CppVector, CppVectorRef, CppVectorPtr}) = begin
    const dest_length = length(dest)
    const src_data = @cxx src->data()
    const src_length = Int(@cxx src->size())

    dest_length < src_length && throw(BoundsError())

    if (src_length < 100)
        # Faster for small sizes:
        for i in 1:src_length
            dest[i] = unsafe_load(src_data, i)
        end
    else
        # Faster for large sizes:
        copy!(dest, pointer_to_array(src_data, src_length, false))
    end

    dest
end


copy!(dest::Union{CppVector, CppVectorRef, CppVectorPtr}, src::Vector) = begin
    const dest_data = @cxx dest->data()
    const dest_length = Int(@cxx dest->size())
    const src_length = length(src)

    dest_length < src_length && throw(BoundsError())

    if (src_length < 100)
        # Faster for small sizes:
        for i in 1:src_length
            unsafe_store!(dest_data, src[i], i)
        end
    else
        # Faster for large sizes:
        copy!(pointer_to_array(dest_data, dest_length, false), src)
    end

    dest
end


resize!(v::Union{CppVector, CppVectorRef, CppVectorPtr}, nl::Integer) =
    (@cxx v->resize(Csize_t(nl)); v)


show(io::IO, x::CppVector) =
    (print(io, "CppVector("); show(io, array_view(x)); print(io, ")"))

show(io::IO, x::CppVectorRef) =
    (print(io, "CppVectorRef("); show(io, array_view(x)); print(io, ")"))


array_view(v::Union{CppVector, CppVectorRef, CppVectorPtr}) =
    pointer_to_array((@cxx v->data()), (@cxx v->size()), false)


end # module



ttree_proxy_value{T}(value::Vector{T}) = CppStd.cpp_vector(T)

set_proxy_from_value!{T}(proxy::CppStd.CppVector{T}, value::Vector{T}) = begin
    resize!(proxy, length(value))
    copy!(proxy, value)
end



#=

v = cpp_vector(Int)
vr = icxx""" auto& ref=$v; ref;"""
vp = icxx""" &$v; """

a = rand(Int32, 50)
resize!(v, length(a))
copy!(v, a)
convert(Vector{Int32}, v) == a

a = rand(Int32, 500)
resize!(vr, length(a))
copy!(vr, a)
convert(Vector{Int32}, vr) == a

a = rand(Int32, 5000)
resize!(vp, length(a))
copy!(vp, a)
convert(Vector{Int32}, vp) == a

=#
