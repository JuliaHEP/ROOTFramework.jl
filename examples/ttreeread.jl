using ROOTFramework, Cxx

rootgui()

bindings = TTreeBindings()
idx = bindings[:idx] = Ref(zero(Int32))
s = bindings[:s] = Ref(zero(Float64))
a = bindings[:a] = Float64[]

tchain = TChain("data", "out.root")
info("$tchain has $(length(tchain)) entries.")

hist = THxx(Float64, -10:0.1:30, "hist", "Hist")

n = 0
@time for _ in TTreeInput(tchain, bindings)
    n += 1
    @assert idx.x == n
    push!(hist, s.x)
    for x in a push!(hist, x) end
end

draw(hist)
