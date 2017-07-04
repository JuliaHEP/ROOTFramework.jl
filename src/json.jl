# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TBufferJSON.h")

export rootjson


rootjson(obj::Cxx.CppValue, compact::Integer = 3) =
	rootjson(pointer_to(obj), compact)

rootjson(obj::Cxx.CppPtr, compact::Integer = 3) =
	string(@cxx TBufferJSON::ConvertToJSON(obj, Int32(compact)))
