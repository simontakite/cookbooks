#!/usr/bin/python

# numpy
import numpy as np
# matplotlib
import matplotlib.pyplot as plt
# networkx nodule
import networkx as nx

# prepare a random graph with n nodes and m edges
n = 16
m = 60
G = nx.gnm_random_graph(n, m)

# prepare a circular layout of nodes
pos = nx.circular_layout(G)
# define the color to select from the color map
# as n numbers evenly spaced between color map limits
node_color = map(int, np.linspace(0, 255, n))

# draw the nodes, specifying the color map and the list of color
# to access it
nx.draw_networkx_nodes(G, pos,
                       node_color=node_color, cmap=plt.cm.hsv) 
# add the labels inside the nodes
nx.draw_networkx_labels(G, pos)
# draw the edges, using alpha parameter to make them lighter
nx.draw_networkx_edges(G, pos, alpha=0.4)

# turn off axis elements
plt.axis('off')

# show the resulting plot
plt.savefig('7900_09_07.png')
plt.show()
