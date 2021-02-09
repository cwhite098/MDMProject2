# -*- coding: utf-8 -*-
"""
Created on Fri Feb  5 15:23:45 2021

@author: kiera
"""
import math
import random
import networkx as nx
import numpy as np
import matplotlib.pyplot as plt
popcount=0

"""
class node:#infectivity base chance of infection per exposure. 0-1
    def __init__(self):
        self.sir=0#0,1,2 suseptible , infected , recovered
        self.infectivity=0.1
        self.exposures=0
    def update(self):
        count =0
        while(count<self.exposures and self.sir > 1):
            count+=1
            if self.infectivity<random.randrange(0,1,0.001):
                self.sir =1
"""
def createnetwork(maxpop,startinfected):
    maxpop=100
    g=nx.complete_graph(maxpop)
    #print(g.nodes(data=True))
    for i in g.nodes(data = True):
        #print("here \n\n here")
        #print(i)
        #print(type(i))
        i[1]["sir"]=0
        i[1]["exposures"]=0
        i[1]["timer"]=0
        n=0
    while n < startinfected:
        n+=1
        g.nodes(data = True)[1]["sir"]=1
    
    
    totals=[maxpop-startinfected,startinfected,0]
    return g,totals

def update(g,totals, infectivity = 0.004):
    for i in g.nodes(data=True):
        
        while(0<i[1]["exposures"] and i[1]["sir"] ==0):
            i[1]["exposures"]-=1
            if infectivity>random.random():#for each exposure infection chance
                i[1]["sir"] =1
                totals[0]-=1
                totals[1]+=1
                
                
    for i in g.nodes(data=True):
        count=0
        

        nei =  list(g.neighbors(i[0]))#every connection to infected adds exposure
        #print(nei)
        """this is done poorly if run slow start here"""
        for j in g.nodes(data=True):
            #print(j)
            #print("here \n\n here")
            
            if j[1]["sir"]==1 and j[0] in nei:#checks if node is suseptible and a neibor of checked node
                count +=1
        i[1]["exposures"]=count
    for i in g.nodes(data= True):
        if i[1]["sir"] == 1:
            i[1]["timer"]+=1
        if i[1]["sir"] == 1 and i[1]["timer"] > 3:#recovers after 8 days
            i[1]["sir"] =2
            totals[1]-=1
            totals[2]+=1
    return g, totals

    
    
g=createnetwork(1000,15)
totals=g[1]
g=g[0]
s=[]
I=[]
r=[]
ticks=100

for k in range(ticks):
    
    tup =update(g,totals)
    g=tup[0]
    data = tup[1]
    s.append(data[0])
    I.append(data[1])
    r.append(data[2])
    x = range(ticks)
plt.plot(x,s)
plt.plot(x,I)
plt.plot(x,r)
