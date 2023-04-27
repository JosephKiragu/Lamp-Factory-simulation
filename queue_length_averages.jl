using CSV, DataFrames, Statistics, BenchmarkTools

valet_data = DataFrame(CSV.File("lamp_factory_data/mean_interarrival45.0/seed1/state.csv",comment="#"))


valet_time_averages = DataFrame()
valet_time_averages[:,:seed] = 1:600

# write a little function to do this (hopefully more efficient than a loop)
# Get average of averages
function get_valet_time_average(seed)
    valet_data = DataFrame(CSV.File("lamp_factory_data/mean_interarrival45.0/seed"*string(seed)*"/state.csv",comment="#"))
    # your code here ...
	queue_length = max.(valet_data.length_queue1 , 0)

    time_average = mean(queue_length) # your code here
    return time_average
end

# complete this line to run the function
valet_time_averages[:,:time_average] = get_valet_time_average.(1:600)
mean(valet_time_averages.time_average)
std(valet_time_averages.time_average)

using Plots


import Measures: pt

# some plot setup commands
p1 = plot(; linetype=:steppost,
          xlabel="time",
          ylabel="customers",
          label="",
          size=(600,200),
          pos = (),
          linewidth=2,
          linecolor=:blue,
          bottom_margin=10pt
          )

for seed in 1:100
    valet_data = DataFrame(CSV.File("data/n_valets3/mean_interarrival2/service_time5/seed"*string(seed)*"/state.csv",comment="#"))
    valet_data[:,:n_waiting]=max.(0,valet_data[:,:n_customers].-3) # creating new column n_waiting
    plot!(p1, valet_data.time, valet_data.n_waiting; linetype=:steppost, label="", alpha=0.4)
end
current()


##############################################################################
############ WINDOWED AVERAGES ###############################################
mean_interarrival = 50.0 # can be the mean inter-arrival rate
times = 0.0:10*mean_interarrival:10000.0
time_length = length(times)
function get_all_windowed_averages(seed)
    valet_data = DataFrame(CSV.File("lamp_factory_data/mean_interarrival45.0/seed"*string(seed)*"/state.csv",comment="#")) #location of output file
	valet_data[:,:n_waiting]=max.(0,valet_data[:,:length_queue1])
    windowed_average = get_one_windowed_average(times,valet_data)
    return windowed_average 
end

# function get_all_windowed_averages_2(seed)
#     valet_data = DataFrame(CSV.File("lamp_factory_data/mean_interarrival60.0/seed"*string(seed)*"/state.csv",comment="#")) #location of output file
# 	valet_data[:,:n_waiting]=max.(0,valet_data[:,:length_queue2])
#     windowed_average = get_one_windowed_average(times,valet_data)
#     return windowed_average 
# end

function get_one_windowed_average(times,valet_data)
    windowed_average = Vector{Float64}(undef, length(times)-1)
    for j ∈ 1:length(times)-1
        windowed_average[j] = mean(valet_data[times[j].<=valet_data.time.<times[j+1],:n_waiting])
    end
    return windowed_average
end

all_windowed_averages_1 = get_all_windowed_averages.(1:600) 
# all_windowed_averages_2 = get_all_windowed_averages_2.(1:600) 
mean_windowed_averages_1 = Vector{Float64}(undef, length(times)-1) 
# mean_windowed_averages_2 = Vector{Float64}(undef, length(times)-1) 
for j ∈ 1:length(times)-1
    mean_windowed_averages_1[j] = mean(getindex.(all_windowed_averages_1,j))
	# mean_windowed_averages_2[j] = mean(getindex.(all_windowed_averages_2,j))
end

indices = findall(isnan, mean_windowed_averages) # function to check whether you have a null window

mean(mean_windowed_averages_1) # Get the overall mean
# mean(mean_windowed_averages_2)
std(mean_windowed_averages) # Get the overall standard deviation

# some plotting
using Plots
import Measures: pt

# plot command as per notes
p1 = plot(; linetype=:steppost,
          xlabel="time",
          ylabel="Lamp orders",
          label="",
          size=(600,200),
          pos = (),
          linewidth=2,
          linecolor=:blue,
          bottom_margin=10pt
          ) 

for seed in 1:100
    valet_data = DataFrame(CSV.File("lamp_factory_data/mean_interarrival45.0/seed"*string(seed)*"/state.csv",comment="#"))
    valet_data[:,:n_waiting]=max.(0,valet_data[:,:length_queue1])
    plt = plot!(p1, valet_data.time, valet_data.n_waiting; linetype=:steppost, label="", alpha=0.1)
end 
current() 

plot!(p1,times[1:end-1],mean_windowed_averages_1,label="queue 1",linetype=:steppost,linewith=2,color=:black) 
plot!(p1,times[1:end-1],mean_windowed_averages_2,label="queue 2",linetype=:steppost,linewith=2,color=:black) 
mkdir("Plots")
savefig(p1, "Plots/600_seed_machine1-change-interarrival45-windowed-average.png")
