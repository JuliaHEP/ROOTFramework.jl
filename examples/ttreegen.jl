# using Cxx, ROOTFramework, ROOTFramework.CppStd, Distributions, Benchmarks; import CxxStd

using ROOTFramework
using Distributions


output = TTreeOutput("data", "Data")

idx = output[:idx] = Ref{Int32}(0)
s = output[:s] = Ref(0.0)
a = output[:a] = [0.0, 0.0]

tfile = TFile("out.root", "recreate")
open(output, tfile)

s_dist = Normal(2.0, 2.0)
a_dist = [Normal(12.0, 2.0), Normal(22.0, 2.0)]

@time for entry in 1:1000000
    idx.x = entry
    s.x = rand(s_dist)

    a[1] = rand(a_dist[1])
    a[2] = rand(a_dist[2])

    push!(output)
end

close(output)
close(tfile)
