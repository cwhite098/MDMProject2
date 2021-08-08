# MDM2 Project 2 - Studying Infectious Diseases on Networks

## Aims
The aim of this project is to extend the traditional SIR model of infectoious diseases using graph theory and social networks.
We hoped to see how changing the structure of the network will change the rate of disease spread, the peak number of infections and other metrics of interest.


## Usage
The program is written entirely in MATLAB and there are two main ways to interact with it:

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
