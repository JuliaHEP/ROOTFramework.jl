using ROOTFramework, ROOTFramework.CppStd
using Distributions


tfile = TFile("out.root", "recreate")
ttree = create_ttree!(tfile, "data", "Data")

idx = Ref{Int32}(0)
s = Ref(0.0)
a = [0.0, 0.0]
cpp_a = cpp_vector(Float64, 2)

create_branch!(ttree, "idx", idx)
create_branch!(ttree, "s", s)
create_branch!(ttree, "a", cpp_a)

s_dist = Normal(2.0, 2.0)
a_dist = [Normal(12.0, 2.0), Normal(22.0, 2.0)]

@time for entry in 1:1000000
    idx.x = entry
    s.x = rand(s_dist)

    a[1] = rand(a_dist[1])
    a[2] = rand(a_dist[2])
    resize!(cpp_a, length(a))
    copy!(array_view(cpp_a), a)

    push!(ttree)
end

close(tfile)
