using ROOTFramework

output = TTreeOutput("data", "Data")

idx = output[:idx] = Ref{Int32}(0)
s = output[:s] = Ref(0.0)
a = output[:a] = [0.0, 0.0]

open(TFile, "out.root", "recreate") do tfile
    open(output, tfile)

    @time for entry in 1:1000000
        idx.x = entry
        s.x = 2.0 + 2.0 * randn()

        a[1] = 12.0 + 2.0 * randn()
        a[2] = 22.0 + 2.0 * randn()

        push!(output)
    end

    close(output)
end
