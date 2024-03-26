using CSV, DataFrames, Dates

data_in_question = "moonquake_all_stations"
variable="sea_level"

path = "./data/"
filepath = path * data_in_question * ".csv"
df = CSV.read(filepath, DataFrame);


# perturbes all data with a random value between a percentage of max
function perturbation(df, variable, percentage_perturbation)
    df[!,variable] = Float64.(df[!,variable])
    max_p = (maximum(df[!,variable]) - minimum(df[!,variable])) * percentage_perturbation/100

    for i in eachindex(df, 1)
        df[i,:][variable] = round(df[i,:][variable]+1*rand(-max_p:0.001:max_p), digits=2)
    end

    return(df)
end


mkpath("./data_perturbed/")
for index in 1:5
    df_perturbed = perturbation(df, variable)
    CSV.write("./data_perturbed/hourly_sea_level_perturbed_trial_$(index).csv", df_perturbed, delim=",")
end