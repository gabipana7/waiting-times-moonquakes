using CSV, DataFrames, Dates
using PyCall
using CairoMakie

@pyimport powerlaw as powlaw
so = pyimport("scipy.optimize")

fit_tsallis = pyeval("""lambda fit: lambda a, b, c, d: fit(a, b, c, d)""")
@. tsallis_ccdf(x, α, λ, c) = c*((1+x/(λ))^(-α))


function rescale_data(data)
    r_min = minimum(data)
    r_max = maximum(data)
    t_min = 0.00001
    t_max = 1.0

    new_data = [(((m - r_min)/(r_max - r_min))*(t_max-t_min)+t_min) for m in data]
    return new_data
end


# datetime = "datetime"
# data_in_question = "moonquakes_all_stations"
# deltas = [0.5, 1.5, 3.0, 5.0]
# day_hour = "days"

datetime = "datetime"
data_in_question = "marsquakes_mw"
deltas = [1.0, 1.5, 1.7, 2.0]
day_hour = "hours"


set_theme!(Theme(fonts=(; regular="CMU Serif")))

markers=[:utriangle, :diamond, :circle, :circle]
colors=[:lightblue, :lightgreen, :lightsalmon, :orchid]
line_colors=[:midnightblue, :green, :darkred, :purple]

########################################### ALL
# CCDF of all data scattered 
fig = Figure(resolution = (800, 700), font= "CMU Serif") 
ax1 = Axis(fig[1,1], xlabel = L"k\, \mathrm{[%$(day_hour)]}", ylabel = L"P_k", ylabelsize = 28, xscale=log10, yscale=log10,   
    xlabelsize = 28, xgridstyle = :dash, ygridstyle = :dash, xtickalign = 1,
    xticksize = 5, ytickalign = 1, yticksize = 5 , xlabelpadding = 10, ylabelpadding = 10, xticklabelsize=22, yticklabelsize=22)
    
sc = Array{Any,1}(undef,length(deltas))

for i in eachindex(deltas)
    delta = deltas[i]

    wt_df = CSV.read("./results/$(data_in_question)/wt/wt_$(data_in_question)_delta_$(delta).csv", DataFrame)
    wt = wt_df[!,:wt];

    x_ccdf_original_data, y_ccdf_original_data = powlaw.ccdf(wt)
    # x_ccdf_original_data = x_ccdf_original_data ./ maximum(x_ccdf_original_data)
    # y_ccdf_original_data = rescale_data(y_ccdf_original_data)

    popt_tsallis, pcov_tsallis = so.curve_fit(fit_tsallis((x, α, λ, c)->tsallis_ccdf(x, α, λ, c)), x_ccdf_original_data, y_ccdf_original_data, bounds=(0, Inf), maxfev=3000)

    alpha = round(popt_tsallis[1], digits=4)
    lambda = round(popt_tsallis[2], digits=4)
    c = round(popt_tsallis[3], digits=4)
    println("alpha= ", popt_tsallis[1],"\nlambda= ", popt_tsallis[2], "\nc= ", popt_tsallis[3])

    #############################################################################################################################################################
    # THE PLOTS 

    sc[i] = scatter!(ax1, x_ccdf_original_data, y_ccdf_original_data,
    color=(colors[i], 0.75), strokewidth=0.05, strokecolor=(line_colors[i], 0.8), marker=markers[i], markersize=12)

    lines!(ax1, x_ccdf_original_data, tsallis_ccdf(x_ccdf_original_data, popt_tsallis[1], popt_tsallis[2], popt_tsallis[3]), label= L"\alpha=%$(alpha),\, \lambda=%$(lambda),\, c=%$(c)",
    color=(line_colors[i], 0.7), linewidth=3)

end

# AXIS LEGEND
axislegend(ax1, [sc[i] for i in eachindex(deltas)], 
[L"\delta=%$(deltas[i])" for i in eachindex(deltas)],
position = :lc, backgroundcolor = (:grey90, 0.25), labelsize=18, titlesize=18);

axislegend(ax1, position = :lb, backgroundcolor = (:grey90, 0.25), labelsize=18);

save("./results/$(data_in_question)/tsallis/wt_tsallis_$(data_in_question)_overlayed.png", fig, px_per_unit=5)
fig