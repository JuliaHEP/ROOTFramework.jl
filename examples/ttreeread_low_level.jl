using ROOTFramework, Cxx

#rootgui()

idx = Ref{Int32}(0)
s = Ref(0.0)
a = [0.0, 0.0]
cpp_a = icxx""" std::vector<double>(2); """

hist = THxx(Float64, -10:0.1:30, "hist", "Hist")

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
        push!(hist, s.x)
        for x in a push!(hist, x) end
    end
end

draw(hist)
