# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).


using Cxx


typealias CppVector{T} cxxt"std::vector<$T>"
typealias CppVectorRef{T} cxxt"std::vector<$T>&"
typealias CppVectorPtr{T} Cxx.CppPtr{Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{Symbol("std::vector")},Tuple{T,Cxx.CxxQualType{Cxx.CppTemplate{Cxx.CppBaseType{Symbol("std::allocator")},Tuple{T}},(false,false,false)}}},(false,false,false)},(false,false,false)}


cpp_vector{T}(::Type{T}) =
    icxx""" std::vector<$T>(); """

cpp_vector{T}(::Type{T}, n::Integer) = begin
    v = cpp_vector(T)
    resize!(v, n)
end


ttree_proxy_value{T}(value::Vector{T}) = cpp_vector(T)

set_proxy_from_value!{T}(proxy::CppVector{T}, value::Vector{T}) = begin
    resize!(proxy, length(value))
    copy!(proxy, value)
end
