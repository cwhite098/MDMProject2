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
def starwithinterconect(avpop,populationvariance,avconectivity,connectivityvariance,numclusters,interclusterconnect,centralclusterconnect,centralclusterfactor=1,popcount=0):
    #central cluster has increased pop
    #degrees = sorted(centralcluster.degree, key=lambda x: x[1], reverse=True)
    #station=degrees[0] #main connection to outerclusters
    clusters=[]
    (centralcluster,popcount)=creatcluster(centralclusterfactor*avpop,populationvariance,avconectivity,connectivityvariance,popcount)#central cluster has increased pop
    g=nx.Graph()
    g=nx.compose(g,centralcluster)
    for i in range(numclusters):
        print("creating intercluster connections \n\n\n")
        (cluster,popcount)=creatcluster(avpop,populationvariance,avconectivity,connectivityvariance,popcount)
        g=nx.compose(g,cluster)
        clusters.append(cluster)
    for p in clusters:
        startpoints2=random.choices(list(p.nodes()),k=centralclusterconnect)
        endpoints2 =random.choices(list(centralcluster.nodes()),k=centralclusterconnect)
        
        startpoints=random.choices(list(p.nodes()),k=interclusterconnect)
        endpoints =random.choices(list(g.nodes()),k=interclusterconnect)
        for l in range(interclusterconnect):
            g.add_edge(startpoints[l],endpoints[l])
            g.add_edge(startpoints2[l],endpoints2[l])
    print(popcount)
    return g
def creatcluster(avpop,populationvariance,avconectivity,connectivityvariance,popcount):#popcount previous pop before addition of cluster
    print("creating cluster\n\n\n")
    pop=random.randrange(avpop,int((avpop*populationvariance)))#population of cluster
    temp = nx.Graph()
    pop =popcount+pop#highest value primary key node of cluster    
    #pop=range(pop)
    for i in range(popcount,pop):
        
        temp.add_node(i)#adds node for each pop 
    
    """each node connected to a random sample of other nodes"""
            
    for i in temp.nodes():
        connectivity=random.randrange(avconectivity-connectivityvariance,avconectivity+connectivityvariance)
        numconnection= int(pop*connectivity)#number of connections current node in cluster has        
        connections= np.random.choice(temp.nodes(),size=numconnection)#random set of nodes
        
        for j in connections:
            temp.add_edge(i,j)   #https://stackoverflow.com/questions/28488559/networkx-duplicate-edges/51611005
            #apparently wont add repeated edges
    return temp, pop

def drawcolour(g,k):
    colour_map=[]
    for node in g.nodes(data=True):
        if node[1]["sir"]==1:
            colour_map.append('red')
        elif node[1]["sir"]==2:
            colour_map.append('green')
        else:
            colour_map.append("blue")
    plt.figure(k)
    nx.draw(g,node_color=colour_map)
def createnetwork(maxpop,startinfected):
    g=starwithinterconect(20,2,12,1,5,5,5,centralclusterfactor=4)
    #g=nx.complete_graph(maxpop)#replace this line for different graph 
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

def update(g,totals,visits, infectivity = 0.08):
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
        nei= random.sample(nei,visits)
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

    
    
g=createnetwork(100,5)
totals=g[1]
g=g[0]
s=[]
I=[]
r=[]
ticks=50

for k in range(ticks):
    
    tup =update(g,totals,20)
    
    g=tup[0]
    data = tup[1]
    drawcolour(g,k)
    s.append(data[0])
    I.append(data[1])
    r.append(data[2])
    x = range(ticks)

#plt.plot(x,s, label = "S")
#plt.plot(x,I,label = "I")
#plt.plot(x,r,label = "R")
#nx.draw(g)
plt.legend()
