# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 13:22:05 2021

@author: kiera
"""

import random
import networkx as nx
import numpy as np


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
def createwhole(avpop,populationvariance,avconectivity,connectivityvariance,numclusters,interclusterconnect,centralclusterfactor=1,popcount=0):
    #central cluster has increased pop
    #degrees = sorted(centralcluster.degree, key=lambda x: x[1], reverse=True)
    #station=degrees[0] #main connection to outerclusters
    clusters=[]
    
    g=nx.Graph()
    for i in range(numclusters):
        #print("creating intercluster connections \n\n\n")
        (cluster,popcount)=creatcluster(avpop,populationvariance,avconectivity,connectivityvariance,popcount)
        g=nx.compose(g,cluster)
        clusters.append(cluster)
    for p in clusters:
        startpoints=random.choices(list(p.nodes()),k=interclusterconnect)
        endpoints =random.choices(list(g.nodes()),k=interclusterconnect)
        for l in range(interclusterconnect):
            g.add_edge(startpoints[l],endpoints[l])
    
    print(popcount)
    return g
def createwholestar(avpop,populationvariance,avconectivity,connectivityvariance,numclusters,interclusterconnect,centralclusterfactor=1,popcount=0):
    (centralcluster,popcount)=creatcluster(centralclusterfactor*avpop,populationvariance,avconectivity,connectivityvariance,popcount)#central cluster has increased pop
    #degrees = sorted(centralcluster.degree, key=lambda x: x[1], reverse=True)
    #station=degrees[0] #main connection to outerclusters
    interclusters=[]
    for i in range(numclusters):
        #print("creating intercluster connections \n\n\n")
        (cluster,popcount)=creatcluster(avpop,populationvariance,avconectivity,connectivityvariance,popcount)
        centralconnections=random.choices(list(centralcluster.nodes()),k=interclusterconnect)#list if random nodes from central
        for j in range(interclusterconnect):
            
            interclusters.append((list(cluster.nodes())[j],centralconnections[j]))
        #degrees = sorted(cluster.degree, key=lambda x: x[1], reverse=True)
        #outerstation = degrees[0]
        centralcluster= nx.compose(centralcluster,cluster)
    """move out of forloop one layer to lose star"""
    #for k in interclusters:
        #centralcluster.addedge(k)
    centralcluster.add_edges_from(interclusters)
    print(popcount)
    return centralcluster
def starwithinterconect(avpop,populationvariance,avconectivity,connectivityvariance,numclusters,interclusterconnect,centralclusterconnect,centralclusterfactor=1,popcount=0):
    #central cluster has increased pop
    #degrees = sorted(centralcluster.degree, key=lambda x: x[1], reverse=True)
    #station=degrees[0] #main connection to outerclusters
    clusters=[]
    (centralcluster,popcount)=creatcluster(centralclusterfactor*avpop,populationvariance,avconectivity,connectivityvariance,popcount)#central cluster has increased pop
    g=nx.Graph()
    g=nx.compose(g,centralcluster)
    for i in range(numclusters):
        #print("creating intercluster connections \n\n\n")
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


"""star with interconnect is same as "complete whole" but with a central cluster with atleast one 
conection to each cluster.
complete whole is a graph with clusters spread out and randomly interconnected im not sure what 
the proper name is but we shouldnt carry on with "create whole"
we can only compare these graphs if all parameters are equal which they should be rn as they come from the same variable. 
the only difference should be the added central cluster. 
order of parameters are the same for each function.
"""
#key (avgclusterpop,populationvariance,avconectivity,connectivityvariance,numclusters,interclusterconnect,centralclusterconnect,centralclusterfactor=1,popcount=0
clustercount = 40#for both network types the number of clusters generated
clusterpop=20#avg number of nodes in each cluster total pop approx = clustercount*clusterpop
interclusterconnectivity = 2 #average number of connections randomly added between clusters in both graph types, is a measure of interconnectivity in a society.
network=starwithinterconect(clusterpop,interclusterconnectivity,15,1,clustercount-1,2,5,centralclusterfactor=2)
#network=createwhole(clusterpop,interclusterconnectivity,15,1,clustercount,2,5)

#tbh this is overengineered all we will likely need to change is numclusters average cluster connect and numclusters. all the other bollax can be left. 

A = nx.adjacency_matrix(network)
nx.draw(network, node_size=30)


#print("spring \n\n")
#nx.draw_spring(network, node_size=60)

#print("spectral \n\n")
#nx.draw_spectral(network, node_size=60)#best

#print("shell \n\n")
#nx.draw_shell(network, node_size=60)