using ROOTFramework, Cxx

rootgui()

tchain = TChain("data", "out.root")

idx = Ref{Int32}(0)
s = Ref(0.0)
a = [0.0, 0.0]
cpp_a = icxx""" std::vector<double>(2); """

bind_branch!(tchain, "idx", idx)
bind_branch!(tchain, "s", s)

cpp_a_ref = Ref(icxx"&$cpp_a;")
bind_branch!(tchain, "a", cpp_a_ref)

info("$tchain has $(length(tchain)) entries.")

hist = THxx(Float64, -10:0.1:30, "hist", "Hist")

@time for i in tchain
    copy!(a, cpp_a)

    assert(idx.x == i + 1)
    push!(hist, s.x)
    for x in a push!(hist, x) end
end

draw(hist)
