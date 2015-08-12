#!/usr/bin/python

# Numpy and Matplotlib
import numpy as np
import matplotlib.pyplot as plt

# the known points set
data = [[2,2],[5,0],[9,5],[11,4],[12,7],[13,11],[17,12]]

# we extract the X and Y components from previous points
x, y = zip(*data)

# plot the data points with a black cross
plt.plot(x, y, 'kx')

# we want a bit more data and more fine grained for
# the fitting functions
x2 = np.arange(min(x)-1, max(x)+1, .01)

# lines styles for the polynomials
styles = [':', '-.', '--']

# getting style and count one at time
for d, style in enumerate(styles):
    # degree of the polynomial
    deg = d + 1
    # calculate the coefficients of the fitting polynomial
    c = np.polyfit(x, y, deg)
    # we evaluate the fitting function against x2
    y2 = np.polyval(c, x2)
    # and then we plot it, label is the polynomial degree
    # and the line style is selected from the list
    plt.plot(x2, y2, label="deg=%d" % deg, linestyle=style)

# show the legend
plt.legend(loc='upper left')

# show the plot
plt.savefig('7900_09_05.png')
plt.show()
