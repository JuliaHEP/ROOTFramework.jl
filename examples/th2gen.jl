using Cxx, ROOTFramework, Distributions, PDMats
import JSON

rootgui()
set_default_palette(:viridis)

hist = THxx((-10:0.5:10, -10:0.5:10), "hist", "Hist")

dist = MvNormal([0.0, 0.0], ScalMat(2, 5.0))
@time for i in 1:100000
    push!(hist, (rand(dist)...))
end
draw(hist, "lego2")
# draw(hist, "colz1")

tfile = TFile("out.root", "recreate")
write(tfile, hist)
close(tfile)

hist_dict = JSON.parse(rootjson(hist))
