# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx


Base.lock(mutex::TVirtualMutexPtr) = @cxx mutex->Lock();

Base.unlock(mutex::TVirtualMutexPtr) = @cxx mutex->UnLock();

gROOTMutex() = icxx"gROOTMutex;"
