using Cxx, ROOTFramework, Distributions
import JSON

rootgui()

hist = THxx(-20:0.2:20, "hist", "Hist")

dist = Normal(0.0, 5.0)
@time for i in 1:10000
    push!(hist, rand(dist))
end
draw(hist)

fit(hist, "gaus")
draw(hist)

tfile = TFile("out.root", "recreate")
write(tfile, hist)
close(tfile)

hist_dict = JSON.parse(rootjson(hist))


#=
new_TBrowser();
=#
