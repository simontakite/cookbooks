#!/usr/bin/python

# to access standard output
import sys

# select a non-GUI backend
import matplotlib
matplotlib.use('Agg')

# import plotting module
import matplotlib.pyplot as plt

# generate the plot
plt.plot([1,2,3,2,3,4])

# print the content type (what's the data type)
# the new line is embedded, using '\n' notation
print "Content-Type: image/png\n"

# output directly to webserver, as a png file
plt.savefig(sys.stdout, format='png')

