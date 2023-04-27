# import Pkg
# Pkg.add("Tables")
using Tables, CSV, Distributions, StatsPlots

data = CSV.File("/Users/josephkiragu/Desktop/Decision science/Assesment 3/measured_times.csv")

matrix_data = Tables.matrix(CSV.File("/Users/josephkiragu/Desktop/Decision science/Assesment 3/measured_times.csv"))

inter_a = matrix_data[:,1]
inter_b = matrix_data[:,2]
inter_c = matrix_data[:,3]

#### Inter arrival time
inter_arrival_histogram = histogram(inter_a, normalize = true, title = "inter-arrival histogram")

μ = inter_a |> mean
σ = inter_a |> std


inter_arrival_QQ = qqplot(inter_a, Exponential(60.0), title = "QQ-plot of interarrival_time with mean = 60")
qqplot(inter_a, Exponential(μ), title = "QQ-plot of interarrival_time with mean = 60.2975")

savefig(inter_arrival_histogram, "Plots/inter_arrival_histogram.png")
savefig(inter_arrival_QQ, "Plots/inter_arrival_QQ.png")
#### Machine time 1
machine_1_histogram = histogram(inter_b, normalize = true, title = "Machine 1 histogram")

μ = inter_b |> mean
σ = inter_b |> std

qqplot(inter_b, Normal(μ, σ), title = "Machine time 1 with normal distribution")
machine_1_QQ =  qqplot(inter_b, Normal(25.0, 7), title = "Machine time 1 with mean = 25, std = 7")
machine_1_Detetministic_QQ = qqplot(inter_b, Uniform(), title = "machine 1 deterministic")
savefig(machine_1_histogram, "Plots/machine_1_histogram.png")
savefig(machine_1_QQ, "Plots/machine_1_QQ.png")
savefig(machine_1_Detetministic_QQ, "Plots/machine_1_Detetministic_QQ.png")

distribution = Deterministic([1, 2, 3, 4, 5])

#### Machine time 2

machine_2_histogram = histogram(inter_c, normalize = true, title = "Machine time 2 histogram")

μ = inter_c |> mean
σ = inter_c |> std
qqplot(inter_c, Exponential(μ), title = "Macine time 2 with actual mean = 59.028")
machine_2_QQ =  qqplot(inter_c, Exponential(59.0), title = "Machine time 2 with mean = 59")

savefig(machine_2_histogram, "Plots/machine_2_histogram.png")
savefig(machine_2_QQ, "Plots/machine_2_QQ.png")