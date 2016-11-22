using ROOTFramework, Cxx
import JSON

# Init GUI, open output file and create canvas

rootgui()
set_default_palette(:viridis)

tfile = open(TFile, "out.root", "recreate")

canvas = @cxxnew TCanvas(pointer("histplots"), pointer("Histogram Plots"))
@cxx canvas->Divide(2, 2)

# TH1

hist1 = THxx(-20:0.2:20, "hist1", "Hist")

@time for i in 1:10000
    push!(hist1, 5.0 * randn())
end
@cxx canvas->cd(1)
draw(hist1)

ROOTFramework.fit(hist1, "gaus")
draw(hist1)

write(tfile, hist1)
hist_dict1 = JSON.parse(rootjson(hist1))

# TH2

set_default_palette(:viridis)

hist2 = THxx((-10:0.5:10, -10:0.5:10), "hist2", "Hist2")

@time for i in 1:100000
    push!(hist2, (3.0 * randn(), 3.0 * randn()))
end
@cxx canvas->cd(2)
draw(hist2, "lego2")
@cxx canvas->cd(3)
draw(hist2, "colz1")

write(tfile, hist2)
hist_dict2 = JSON.parse(rootjson(hist2))


# TH3

hist3 = THxx((-10:0.5:10, -10:0.5:10, -10:0.5:10), "hist3", "Hist")

@time for i in 1:100000
    push!(hist3, (3.0 * randn(), 3.0 * randn(), 3.0 * randn()))
end
@cxx canvas->cd(4)
draw(hist3)

write(tfile, hist3)
hist3_dict = JSON.parse(rootjson(hist3))


# Done

write(tfile, canvas)

close(tfile)


#=
new_TBrowser();
=#
