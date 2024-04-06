using CSV, DataFrames, Dates

# data_in_question = "moonquakes_all_stations"
# variable = "amplitude"
# # deltas = 0.1:0.1:1.5
# deltas = 0.1:0.1:2.0


data_in_question = "marsquakes_mw"
variable = "mw"
deltas = 1.0:0.1:3.0

path = "./data/"
filepath = "./data/" * data_in_question * ".csv"
df = CSV.read(filepath, DataFrame);

mkpath("./results/$(data_in_question)/wt/")

function waiting_times(df, delta, datetime, variable)
    wtid = []
    for (i,k) in enumerate(df[!,variable])
        first_event = df[!,datetime][i]
        for (j,x) in enumerate(df[i+1:end, variable])
            if x >= (k+delta)
                second_event = df[!,datetime][i+j]
                push!(wtid, trunc(Int, Dates.value(second_event - first_event) / 150000) )
                break
            end
        end
    end
    return wtid
end



datetime = "datetime"
for delta in deltas
    wt = waiting_times(df, delta, datetime, variable)
    wt_dataframe = DataFrame([wt], ["wt"])
    CSV.write("./results/$(data_in_question)/wt/wt_$(data_in_question)_delta_$(delta).csv", wt_dataframe, delim=",")
end
