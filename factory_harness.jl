using CSV, DataFrames
# include the simulation code
include("factory_simulation_2.jl")


# inititialise
# seed = 1

T = 10_000.0
mean_interarrival = 45.0 ###    units here are minutes
mean_machine_times = [21 , 59]
max_queue = [typemax(Int64), 4]
time_units = "minutes"
# P = Parameters( seed, T, mean_interarrival, mean_machine_times, max_queue, time_units)

# choose a final time
# final_time = 10_000.0

# choose some seed values
seeds = 1:600

# rerun simulation if output already exists?
rerun = false

# "Simulation harness" ... loop over seeds and parameters values
for seed in seeds    
    P = Parameters( seed, T, mean_interarrival, mean_machine_times, max_queue, time_units)
    if rerun || any(.!isfile.(output_files(P)))
        run_lamp_sim(P)
    end
end

###########################################################################################
#################### Calculating ensemble averages ##################################
numbers = []
difference = (25 - 12.5) / 10
push!(numbers, 12.5)
for i in 1 : 9
	push!(numbers, round((numbers[end] + difference), digits = 1))
end
numbers = reverse(numbers)
time = []
for i in 1:10
	push!(time, [numbers[i], 59])
end
# time[end] = [12.5, 59]
time
# numbers[end] = 12.5
numbers



valet_time_averages = DataFrame()
valet_time_averages[:,:seed] = 1:600
mean_interarrival = 60.0

#machine_times = [[12.52795, 59.0285], [25.0559, 29.51425]]
# machine_times = [[(25 / 2), 59], [25, (59 / 2)]]
machine_times = time
function get_valet_time_average(seed)
	valet_data = DataFrame(CSV.File("lamp_factory_data/mean_interarrival60.0/seed"*string(seed)*"/state.csv",comment="#"))
	# your code here ...
	queue_length = max.(valet_data.length_queue1 , 0)

	time_average = mean(queue_length) # your code here
	return time_average
end

ensemble_averages = Vector{Float64}(undef, length(machine_times))
ensemble_stds = Vector{Float64}(undef, length(machine_times))
for (index, time) in enumerate(machine_times)
	println("Running for time = $(time)")
	for seed in seeds    
		P = Parameters( seed, T, mean_interarrival, time, max_queue, time_units)
		if rerun || any(.!isfile.(output_files(P)))
			run_lamp_sim(P)
		end
	end
	# complete this line to run the function
	valet_time_averages[:,:time_average] = get_valet_time_average.(1:600)
	ensemble_averages[index] = mean(valet_time_averages.time_average)
	ensemble_stds[index] = std(valet_time_averages.time_average)
	println("average = $(ensemble_averages[index])")
	println("std = $(ensemble_stds[index])")
end






println(ensemble_averages)
println(ensemble_stds)

p2 = plot(; linetype=:steppost,
          xlabel="time",
          ylabel="customers",
          label="",
          size=(600,200),
          pos = (),
          linewidth=2,
          linecolor=:blue,
          bottom_margin=10pt
          )


plot!(p2,[(25.0559 / 2), (59.0285 / 2)], ensemble_averages; linetype=:steppost, label="", alpha=0.4)
current()

some_labels= ["m1 = 12.5", "m2 = 29.5"]
p3 = plot(numbers, ensemble_averages, seriestype=:scatter,alpha=0.2,xlim=[0,40.0], xlabel="machine 1 time",
ylabel="machine 1 queue length",series_annotations = text.(some_labels), title = "Machine times vs length of queue 1",  label = "machine times")

p4 = plot(numbers, ensemble_averages, color=[:black :orange], line=(:dot, 4), marker=([:hex :d], 12, 0.8, Plots.stroke(3, :gray)), xlabel="machine time",
ylabel="machine 1 queue length",title = "Machine 1 possibility space")


savefig(p4, "Plots/seed_600_machine_1_possibility_space_version_2.png")


###################################################################################
################### DETERMING THE APPROPRIATE NUMBER OF SEEDS TO USE ##############

valet_time_averages = DataFrame()
valet_time_averages[:,:seed] = 1:600
mean_interarrival = 60.0

#machine_times = [[12.52795, 59.0285], [25.0559, 29.51425]]
machine_times = [25, 59]
function get_valet_time_average(seed)
	valet_data = DataFrame(CSV.File("lamp_factory_data/seed_testing/mean_interarrival60.0/seed"*string(seed)*"/state.csv",comment="#"))
	# your code here ...
	queue_length = max.(valet_data.length_queue1 , 0)

	time_average = mean(queue_length) # your code here
	return time_average
end

time_averages = Vector{Float64}(undef, 20)
time_index = Vector{Float64}(undef, 20)

times = collect(10000:200000)
i = 0
for (index, time) in enumerate(times)  
	if time % 10000 == 0
		# seeds_2 = collect(1:seed)  
		for seed in (1:600)
			P = Parameters( seed, time, mean_interarrival, machine_times, max_queue, time_units)
			if rerun || any(.!isfile.(output_files(P)))
				run_lamp_sim(P)
			end
		end
		# valet_time_averages = DataFrame()
		# valet_time_averages[:,:seed] = 1:seed
		valet_time_averages[:,:time_average] = get_valet_time_average.(1:600)
		i += 1
		time_averages[i] = mean(valet_time_averages.time_average)
		time_index[i] = seed
		println("average = $(time_averages[i])")
	end
end
	# complete this line to run the function
	


println(time_averages)
println(time_index)


p2 = plot(; linetype=:steppost,
          xlabel="time",
          ylabel="customers",
          label="",
          size=(600,200),
          pos = (),
          linewidth=2,
          linecolor=:blue,
          bottom_margin=10pt
          )


plot!(p2,[(25.0559 / 2), (59.0285 / 2)], seed_averages; linetype=:steppost, label="", alpha=0.4)
current()

some_labels= ["m1 = 12.5", "m2 = 29.5"]
p3 = plot([(25.0559 / 2), (59.0285 / 2)], seed_averages, seriestype=:scatter,alpha=0.2,xlim=[0,40.0], xlabel="machine time",
ylabel="lamp queue length",series_annotations = text.(some_labels), title = "Machine times vs length of queue 1",  label = "machine times")

p3 = plot(time_index_2, time_averages, color=[:black :orange], line=(:dot, 4), marker=([:hex :d], 12, 0.2, Plots.stroke(3, :gray)), xlabel="Time (Minutes)",
ylabel="average M1 queue length",)


savefig(p3, "Plots/time_10,000-200,000.png")