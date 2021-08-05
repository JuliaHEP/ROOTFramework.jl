using ROOTFramework, Cxx

bindings = TTreeBindings()
idx = bindings[:idx] = Ref(zero(Int32))
s = bindings[:s] = Ref(zero(Float64))
a = bindings[:a] = Float64[]

A = Float64[]

open(TChainInput, bindings, "data", "out.root") do input
    @info "Input has $(length(input)) entries."

    n = 0
    @time for _ in input
        n += 1
        @assert idx[] == n
        append!(A, a)
    end
end

@info length(A)

#=
using Plots
stephist(A)
=#
