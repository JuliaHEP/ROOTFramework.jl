using Cxx, ROOTFramework, Distributions, PDMats
import JSON

# Init GUI, open output file and create canvas

rootgui()
set_default_palette(:viridis)

tfile = TFile("out.root", "recreate")

canvas = @cxxnew TCanvas(pointer("histplots"), pointer("Histogram Plots"))
@cxx canvas->Divide(2, 2)

# TH1

hist1 = THxx(-20:0.2:20, "hist1", "Hist")

dist = Normal(0.0, 5.0)
@time for i in 1:10000
    push!(hist1, rand(dist))
end
@cxx canvas->cd(1)
draw(hist1)

fit(hist1, "gaus")
draw(hist1)

write(tfile, hist1)
hist_dict1 = JSON.parse(rootjson(hist1))

# TH2

set_default_palette(:viridis)

hist2 = THxx((-10:0.5:10, -10:0.5:10), "hist2", "Hist2")

dist = MvNormal([0.0, 0.0], ScalMat(2, 5.0))
@time for i in 1:100000
    push!(hist2, (rand(dist)...))
end
@cxx canvas->cd(2)
draw(hist2, "lego2")
@cxx canvas->cd(3)
draw(hist2, "colz1")

write(tfile, hist2)
hist_dict2 = JSON.parse(rootjson(hist2))


# TH3

hist3 = THxx((-10:0.5:10, -10:0.5:10, -10:0.5:10), "hist3", "Hist")

dist = MvNormal([0.0, 0.0, 0.0], ScalMat(3, 5.0))
@time for i in 1:100000
    push!(hist3, (rand(dist)...))
end
@cxx canvas->cd(4)
draw(hist3)

tfile = TFile("out.root", "recreate")
write(tfile, hist3)
hist3_dict = JSON.parse(rootjson(hist3))


# Done

write(tfile, canvas)

close(tfile)


#=
new_TBrowser();
=#
