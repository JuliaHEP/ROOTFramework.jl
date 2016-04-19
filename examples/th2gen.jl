using Cxx, ROOTFramework, Distributions, PDMats
import JSON

rootgui()

hist = THxx((-20:0.2:20, -20:0.2:20), "hist", "Hist")

dist = MvNormal([0.0, 0.0], ScalMat(2, 5.0))
@time for i in 1:10000
    push!(hist, (rand(dist)...))
end
draw(hist, "col2")

tfile = TFile("out.root", "recreate")
write(tfile, hist)
close(tfile)

hist_dict = JSON.parse(rootjson(hist))
