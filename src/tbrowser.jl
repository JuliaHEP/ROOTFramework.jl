# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TBrowser.h")

export new_TBrowser

export TBrowserPtr
const TBrowserPtr = pcpp"TBrowser"


new_TBrowser() = icxx""" new TBrowser(); """
