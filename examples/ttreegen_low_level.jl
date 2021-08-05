using ROOTFramework, Cxx

tfile = open(TFile, "out.root", "recreate")
ttree = create_ttree!(tfile, "data", "Data")

idx = Ref{Int32}(0)
s = Ref(0.0)
a = [0.0, 0.0]
cpp_a = icxx""" std::vector<double>(2); """

create_branch!(ttree, "idx", idx)
create_branch!(ttree, "s", s)
create_branch!(ttree, "a", cpp_a)

@time for entry in 1:1000000
    idx[] = entry
    s[] = 2.0 + 2.0 * randn()

    a[1] = 12.0 + 2.0 * randn()
    a[2] = 22.0 + 2.0 * randn()
    resize!(cpp_a, length(a))
    copy!(cpp_a, a)

    push!(ttree)
end

close(tfile)
