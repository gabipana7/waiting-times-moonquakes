using CSV, DataFrames, Dates
using PyCall
using CairoMakie

@pyimport powerlaw as powlaw
so = pyimport("scipy.optimize")


# data_in_question = "moonquakes_all_stations"
# variable = "amplitude"
# deltas = collect(0.5:0.5:5)


data_in_question = "marsquakes_mw"
variable = "mw"
# deltas = 0.1:0.1:1.5
deltas = 1.0:0.1:3.0

for delta in deltas

    wt_df = CSV.read("./results/$(data_in_question)/wt/wt_$(data_in_question)_delta_$(delta).csv", DataFrame)
    wt = wt_df[!,:wt]

    mkpath("./results/$(data_in_question)/tsallis/")

    x_ccdf_original_data, y_ccdf_original_data = powlaw.ccdf(wt)

    fit_tsallis = pyeval("""lambda fit: lambda a, b, c, d: fit(a, b, c, d)""")
    @. tsallis_ccdf(x, α, λ, c) = c*((1+x/(λ))^(-α))
    popt_tsallis, pcov_tsallis = so.curve_fit(fit_tsallis((x, α, λ, c)->tsallis_ccdf(x, α, λ, c)), x_ccdf_original_data, y_ccdf_original_data, bounds=(0, Inf), maxfev=3000)
    println("alpha= ", popt_tsallis[1],"\nlambda= ", popt_tsallis[2], "\nc= ", popt_tsallis[3])

    alpha = round(popt_tsallis[1], digits=4)
    lambda = round(popt_tsallis[2], digits=4)
    c = round(popt_tsallis[3], digits=4)



    # Round up the data
    alpha = round(alpha, digits=2)
    lambda = round(lambda, digits=2)
    c = round(c, digits=4)


    set_theme!(Theme(fonts=(; regular="CMU Serif")))

    markers=[:utriangle, :circle]
    colors=[:lightblue, :lightgreen]
    line_colors=[:midnightblue, :green]
    i=1

    #############################################################################################################################################################
    # THE PLOTS 
    fig = Figure(resolution = (700, 600), font= "CMU Serif") 
    ax1 = Axis(fig[1,1], xlabel = L"hours", ylabel = L"P", xscale=log10, yscale=log10, ylabelsize = 28,
        xlabelsize = 28, xgridstyle = :dash, ygridstyle = :dash, xtickalign = 1,
        xticksize = 5, ytickalign = 1, yticksize = 5 , xlabelpadding = 10, ylabelpadding = 10, xticklabelsize=22, yticklabelsize=22)
        

    ########################################### ALL
    # CCDF of all data scattered 


    sc1 = scatter!(ax1, x_ccdf_original_data, y_ccdf_original_data,
        color=(colors[1], 0.75), strokewidth=0.05, strokecolor=(line_colors[i], 0.8), marker=markers[i], markersize=12)

    # Fit through truncated data
    # Must shift the y values from the theoretical powerlaw by the values of y of original data, but cut to the length of truncated data
    ln1 = lines!(ax1, x_ccdf_original_data, tsallis_ccdf(x_ccdf_original_data, popt_tsallis[1], popt_tsallis[2], popt_tsallis[3]), label= L"\alpha=%$(alpha),\, \lambda=%$(lambda),\, c=%$(c)",
                color=(line_colors[i], 0.7), linewidth=2.5)


    # AXIS LEGEND
    axislegend(ax1, [sc1], 
    [L"\delta=%$(delta)"],
    position = :rt, backgroundcolor = (:grey90, 0.25), labelsize=18, titlesize=18);

    axislegend(ax1, position = :lb, backgroundcolor = (:grey90, 0.25), labelsize=18);

    ylims!(ax1, 10^(-6), 10^(0.7))

    save("./results/$(data_in_question)/tsallis/wt_tsallis_$(variable)_delta_$(delta).png", fig, px_per_unit=5)

end