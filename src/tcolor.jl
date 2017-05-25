# This file is a part of ROOTFramework.jl, licensed under the MIT License (MIT)

using Cxx

export set_default_palette


const color_palette_ids = Dict(
    :deep_sea => 51,
    :grey_scale => 52,
    :dark_body_radiator => 53,
    :blue_yellow => 54,
    :rain_bow => 55,
    :inverted_dark_body_radiator => 56,
    :bird => 57,
    :cubehelix => 58,
    :green_red_violet => 59,
    :blue_red_yellow => 60,
    :ocean => 61,
    :color_printable_on_grey => 62,
    :alpine => 63,
    :aquamarine => 64,
    :army => 65,
    :atlantic => 66,
    :aurora => 67,
    :avocado => 68,
    :beach => 69,
    :black_body => 70,
    :blue_green_yellow => 71,
    :brown_cyan => 72,
    :cmyk => 73,
    :candy => 74,
    :cherry => 75,
    :coffee => 76,
    :dark_rain_bow => 77,
    :dark_terrain => 78,
    :fall => 79,
    :fruit_punch => 80,
    :fuchsia => 81,
    :grey_yellow => 82,
    :green_brown_terrain => 83,
    :green_pink => 84,
    :island => 85,
    :lake => 86,
    :light_temperature => 87,
    :light_terrain => 88,
    :mint => 89,
    :neon => 90,
    :pastel => 91,
    :pearl => 92,
    :pigeon => 93,
    :plum => 94,
    :red_blue => 95,
    :rose => 96,
    :rust => 97,
    :sandy_terrain => 98,
    :sienna => 99,
    :solar => 100,
    :south_west => 101,
    :starry_night => 102,
    :sunset => 103,
    :temperature_map => 104,
    :thermometer => 105,
    :valentine => 106,
    :visible_spectrum => 107,
    :water_melon => 108,
    :cool => 109,
    :copper => 110,
    :gist_earth => 111,
    :viridis => 112
)


set_default_palette(palette::Symbol, alpha::Real = 1.0) = begin
    id = color_palette_ids(palette)
    icxx"gStyle->SetPalette($id, 0, $alpha);"
    nothing
end
