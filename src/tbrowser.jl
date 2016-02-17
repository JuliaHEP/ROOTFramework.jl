# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

export new_TBrowser


new_TBrowser() = icxx""" new TBrowser(); """
