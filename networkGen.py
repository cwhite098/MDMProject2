
import scipy.sparse as sparse
import networkx as nx
from scipy.io import savemat

G = nx.binomial_graph(100000,1/10000)
A = nx.to_scipy_sparse_matrix(G)

savemat('matrix.mat', {'A':A})
