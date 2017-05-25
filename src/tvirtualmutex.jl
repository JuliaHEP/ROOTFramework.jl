# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TROOT.h")
cxxinclude("TVirtualMutex.h")

typealias TVirtualMutexPtr pcpp"TVirtualMutex"


Base.lock(mutex::TVirtualMutexPtr) = @cxx mutex->Lock();

Base.unlock(mutex::TVirtualMutexPtr) = @cxx mutex->UnLock();

gROOTMutex() = icxx"gROOTMutex;"
