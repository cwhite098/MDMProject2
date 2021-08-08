# MDM2 Project 2 - Studying Infectious Diseases on Networks


Either run SIRSolve/SIRDSolve for the ODE solution or call modelNetworkSIR/modelNetworkSIRD as follows

modelNetworkSIRD(a, b, mu, infectivePeriod, tf, n, I0, A)

where a and b are infection parameters, 
mu is the mortality rate (exclude for SIR version),
infectivePeriod is how long the disease lasts, 
tf is how long to run the model for (days),
n is the population size, 
I0 is the number of initially infected and 
A is an adjacency matrix.
