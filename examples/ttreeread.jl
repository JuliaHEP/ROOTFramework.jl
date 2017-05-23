using ROOTFramework, Cxx

# rootgui()

bindings = TTreeBindings()
idx = bindings[:idx] = Ref(zero(Int32))
s = bindings[:s] = Ref(zero(Float64))
a = bindings[:a] = Float64[]

hist = THxx(Float64, -10:0.1:30, "hist", "Hist")

open(TChainInput, bindings, "data", "out.root") do input
    info("Input has $(length(input)) entries.")

    n = 0
    @time for _ in input
        n += 1
        @assert idx.x == n
        push!(hist, s.x)
        for x in a push!(hist, x) end
    end
end

draw(hist)
