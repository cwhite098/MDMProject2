# MDM2 Project 2 - Studying Infectious Diseases on Networks

## Aims
The aim of this project is to extend the traditional SIR model of infectoious diseases using graph theory and social networks.
We hoped to see how changing the structure of the network will change the rate of disease spread, the peak number of infections and other metrics of interest.

## Technologies
MATLAB including built-in graph theory elements and ODE45.
Python including NetworkX to generate graphs.

## Usage
The program is written mostly in MATLAB and there are two main ways to interact with it:

### ODE Solution
To view the ODE solution run the script SIRSolve or SIRDSolve.

### Solution from Network
To view the solution to the problem on a network, call the function modelNetworkSIR or modelNetworkSIRD as follows:

modelNetworkSIRD(a, b, mu, infectivePeriod, tf, n, I0, A)

where a and b are infection parameters, 
mu is the mortality rate (exclude for SIR version),
infectivePeriod is how long the disease lasts, 
tf is how long to run the model for (days),
n is the population size, 
I0 is the number of initially infected and 
A is an adjacency matrix of the network.

### Generating Networks
We decided the use the python module NetworkX to generate our networks for the model since it has a large number and variety of built-in functions for generating different networks. Use networkGen.py to generate the adjacency matrix and then save it as a .mat file to be imported to MATLAB.
