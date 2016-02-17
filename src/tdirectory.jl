# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT).

using Cxx

import Base: cd, show, write, close

export @tmp_tdir_cd
export current_tdirectory
export path


macro tmp_tdir_cd(dir, body)
    quote
        const prev_dir = current_tdirectory()
        try
            cd($dir)
            $body
        finally
            cd(prev_dir)
        end
    end
end


current_tdirectory() = icxx""" (TDirectory*)TDirectory::CurrentDirectory(); """


show(io::IO, x::TDirectoryRef) =
    print(io, "TDirectoryRef(\"$(escape_string(path(x)))\")")

show(io::IO, x::TDirectoryPtr) =
    print(io, "TDirectoryPtr(\"$(escape_string(path(x)))\")")



TFile() = @cxx TFile()

TFile(fname::AbstractString, mode::AbstractString = "", ftitle::AbstractString = "", compress::Integer = 1) = begin
    const prev_dir = current_tdirectory()
    try
        @cxx TFile(pointer(fname), pointer(mode), pointer(ftitle), Int32(compress))
    finally
        cd(prev_dir)
    end
end

show(io::IO, x::TFile) =
    print(io, "TFile(\"$(escape_string(path(x)))\")")

show(io::IO, x::TFilePtr) =
    print(io, "TFilePtr(\"$(escape_string(path(x)))\")")


write(tdir::ATDirectoryInst, obj::Cxx.CppValue, name::AbstractString = "", option::Integer = 0, bufsize::Integer = 0) =
    write(tdir, pointer(obj), name, option, bufsize)

write(tdir::ATDirectoryInst, obj::Cxx.CppPtr, name::AbstractString = "", option::Integer = 0, bufsize::Integer = 0) =
    @tmp_tdir_cd tdir @cxx obj->Write(isempty(name) ? Ptr{UInt8}(0) : pointer(name), Int32(option), Int32(bufsize))


close(tfile::TFileInst) = begin
    @cxx tfile->Write()
    @cxx tfile->Close()
end



cd(dir::ATDirectoryInst) = @cxx dir->cd()

path(dir::ATDirectoryInst) = bytestring(@cxx dir->GetPath())
