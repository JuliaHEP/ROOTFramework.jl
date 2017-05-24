using ROOTFramework, Cxx

#rootgui()

idx = Ref{Int32}(0)
s = Ref(0.0)
a = [0.0, 0.0]
cpp_a = icxx""" std::vector<double>(2); """

A = Float64[]

open(TChainInput, "data", "out.root") do input
    info("Input has $(length(input)) entries.")

    tchain = input.tchain
    bind_branch!(tchain, "idx", idx)
    bind_branch!(tchain, "s", s)

    cpp_a_ref = Ref(icxx"&$cpp_a;")
    bind_branch!(tchain, "a", cpp_a_ref)

    n = 0
    @time for _ in tchain
        copy!(a, cpp_a)
        n += 1
        @assert idx.x == n
        append!(A, a)
    end
end

info(length(A))

#=
using Plots
stephist(A)
=#
