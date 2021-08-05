# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

cxxinclude("TBufferJSON.h")

export rootjson


rootjson(obj::CppValue, compact::Integer = 3) =
	rootjson(pointer_to(obj), compact)

rootjson(obj::CppPtr, compact::Integer = 3) =
	string(@cxx TBufferJSON::ConvertToJSON(obj, Int32(compact)))
