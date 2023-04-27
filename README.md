# Lamp Factory Simulation

This project is a simulation of a lamp factory consisting of two machines (Machine 1 and Machine 2) and a queue for each machine. The goal is to analyze the factory's performance in terms of the average length of the queues and the impact of different machine time configurations.

## Overview

The simulation is based on a discrete-event system and uses a variety of statistical methods to analyze the collected data. The code reads data from a CSV file containing inter-arrival times and machine times for both machines, and then generates histograms and QQ-plots for the inter-arrival times and the machine times.

The main objectives of this project are:

1. Study the behavior of the lamp factory system under different machine time configurations.
2. Determine the most efficient machine time settings to minimize the average length of the queues.
3. Analyze the impact of varying the number of seeds used in the simulation on the results.

## Simulation Model

The lamp factory consists of two machines and a queue for each machine. Customers arrive at the factory following an inter-arrival time distribution. Each machine has its own processing time distribution. Once a customer's lamp is processed by Machine 1, it is placed in the queue for Machine 2.

## Analysis

The project uses Julia and various packages for simulation and data analysis. The analysis includes:

1. Histograms and QQ-plots for inter-arrival times, machine time 1, and machine time 2.
2. Calculation of ensemble averages and standard deviations for different machine time settings.
3. Determination of the appropriate number of seeds to use for the simulation.

## Getting Started

To run the project, follow these steps:

1. Clone the repository and navigate to the project folder.
2. Ensure that you have Julia and the required packages installed.
3. Run the main simulation script to execute the simulation and generate the plots.

## Results

The results of the simulation include histograms and QQ-plots for inter-arrival times and machine times, as well as ensemble averages and standard deviations for different machine time configurations. These results can be used to optimize the performance of the lamp factory and minimize the average length of the queues.
