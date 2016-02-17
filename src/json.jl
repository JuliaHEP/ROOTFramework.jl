# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

export rootjson


rootjson(obj::Cxx.CppValue, compact::Integer = 3) =
	rootjson(pointer(obj), compact)

rootjson(obj::Cxx.CppPtr, compact::Integer = 3) =
	string(@cxx TBufferJSON::ConvertToJSON(obj, Int32(compact)))
