# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

cxxinclude("TDirectory.h")
cxxinclude("TFile.h")

import Base: cd, show, write, open, close

export current_tdirectory
export path


export TDirectoryRef, TDirectoryPtr, TDirectoryInst
const TDirectoryRef = rcpp"TDirectory"
const TDirectoryPtr = pcpp"TDirectory"
const TDirectoryInst = Union{TDirectoryRef, TDirectoryPtr}

export TFile, TFilePtr, TFileInst
const TFile = cxxt"TFile"
const TFilePtr = pcpp"TFile"
const TFileInst = Union{TFile, TFilePtr}

export ATDirectoryInst
const ATDirectoryInst = Union{TDirectoryInst, TFileInst}


current_tdirectory() = begin
    lock(gROOTMutex()) do
        icxx""" (TDirectory*)TDirectory::CurrentDirectory(); """
    end
end


show(io::IO, x::TDirectoryRef) =
    print(io, "TDirectoryRef(\"$(escape_string(path(x)))\")")

show(io::IO, x::TDirectoryPtr) =
    print(io, "TDirectoryPtr(\"$(escape_string(path(x)))\")")


function Base.keys(tdir::ATDirectoryInst)
    tdir_ptr = as_pointer(tdir)
    names = icxx"""
        std::vector<std::string> names;

        TIter nextobj($tdir_ptr->GetList());
        TObject *obj = nullptr;
        while ((obj = (TObject *) nextobj())) {
            // std::cout << obj->GetName() << std::endl;
            names.push_back(obj->GetName());
        }

        TIter nextkey($tdir_ptr->GetListOfKeys());
        TKey *key = nullptr;
        while ((key = (TKey *) nextkey())) {
            // std::cout << key->GetName() << std::endl;
            names.push_back(key->GetName());
        }
        names;
    """

    unique(map(String, names))
end


Base.haskey(tdir::ATDirectoryInst, key::String) = !isnullptr(@cxx tdir->FindKey(pointer(key)))


function Base.getindex(tdir::ATDirectoryInst, key::String)
    ptr = @cxx tdir->Get(pointer(key))
    isnullptr(ptr) ? throw(KeyError(key)) : dyncast(ptr)
end



open(::Type{TFile}, fname::AbstractString, mode::AbstractString = "", ftitle::AbstractString = "", compress::Integer = 1) = begin
    lock(gROOTMutex()) do
        prev_dir = current_tdirectory()
        try
            @cxx TFile(pointer(fname), pointer(mode), pointer(ftitle), Int32(compress))
        finally
            cd(prev_dir)
        end
    end
end

show(io::IO, x::TFile) =
    print(io, "TFile(\"$(escape_string(path(x)))\")")

show(io::IO, x::TFilePtr) =
    print(io, "TFilePtr(\"$(escape_string(path(x)))\")")


write(tdir::ATDirectoryInst, obj::CppValue, name::AbstractString = "", option::Integer = 0, bufsize::Integer = 0) =
    write(tdir, pointer_to(obj), name, option, bufsize)

write(tdir::ATDirectoryInst, obj::CppPtr, name::AbstractString = "", option::Integer = 0, bufsize::Integer = 0) = begin
    cd(tdir) do
       @cxx obj->Write(isempty(name) ? Ptr{UInt8}(0) : pointer(name), Int32(option), Int32(bufsize))
   end
end


close(tfile::TFileInst) = begin
    tfile_ptr = as_pointer(tfile)
    icxx"""
        if ($tfile_ptr->IsWritable()) {
            $tfile_ptr->Write();
            $tfile_ptr->Close();
        }
    """
    nothing
end



cd(dir::ATDirectoryInst) = begin
    lock(gROOTMutex()) do
        @cxx dir->cd()
    end
end

cd(f::Function, dir::ATDirectoryInst) = begin
    prev_dir = current_tdirectory()
    try
        cd(dir)
        f()
    finally
        cd(prev_dir)
    end
end

path(dir::ATDirectoryInst) = unsafe_string(@cxx dir->GetPath())
