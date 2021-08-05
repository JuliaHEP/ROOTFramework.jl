using ROOTFramework

bindings = TTreeBindings()
idx = bindings[:idx] = Ref(zero(Int32))
s = bindings[:s] = Ref(zero(Float64))
a = bindings[:a] = zeros(Float64, 2)

open(TFile, "out.root", "recreate") do tfile
    ttree = create_ttree!(tfile, "data", "Data")
    output = TTreeOutput(ttree, bindings)

    @time for entry in 1:1000000
        idx[] = entry
        s[] = 2.0 + 2.0 * randn()

        a[1] = 12.0 + 2.0 * randn()
        a[2] = 22.0 + 2.0 * randn()

        push!(output)
    end
end
