#!/usr/bin/python

# for file opening made easier
from __future__ import with_statement
# numpy
import numpy as np
# matplotlib plotting module
import matplotlib.pyplot as plt
# matplotlib colormap module
import matplotlib.cm as cm
# Matplotlib font manager
import matplotlib.font_manager as font_manager

# bar width
width = .8

# open CSV file
with open('../data/population.csv') as f:
    # read the first line, splitting the years
    years = map(int, f.readline().split(',')[1:])

    # we prepare the dtype for exacting data; it's made of:
    # <1 string field> <6 integers fields>
    dtype = [('continents', 'S16')] + [('', np.int32)]*len(years)

    # we load the file, setting the delimiter and the dtype above
    y = np.loadtxt(f, delimiter=',', dtype=dtype)

    # "map" the resulting structure to be easily accessible:
    # the first column (made of string) is called 'continents'
    # the remaining values are added to 'data' sub-matrix
    # where the real data are
    y = y.view(np.dtype([('continents', 'S16'),
                         ('data', np.int32, len(years))]))

# extract fields
data = y['data']
continents = y['continents']

x = years[:-2]
x2 = years[-2:]

# prepare the bottom array
b1 = np.zeros(len(years)-2)


# for each line in data
for i in range(len(data)):
    # select all the data except the last 2 values
    d = data[i][:-2]
    # create bars for each element, on top of the previous bars
    bt = plt.bar(range(len(d)), d, width=width,
                 color=cm.hsv(32*(i)), label=continents[i],
                 bottom=b1)
    # update the bottom array
    b1 += d

# prepare the bottom array
b2_1, b2_2 = np.zeros(2), np.zeros(2)

# for each line in data
for i in range(len(data)):
    # extract the last 2 values
    d = data[i][-2:]
    # select the data to compute the fitting function
    y = data[i][:-2]
    # use a polynomial of degree 3
    c = np.polyfit(x, y, 3)
    # create a function out of those coefficients
    p = np.poly1d(c)
    # compute p on x2 values (we need integers, so the map)
    y2 = map(int, p(x2))
    # create the bars for each element, on top of the previous bars
    bt = plt.bar(len(b1)+np.arange(len(d)), d, width=width/2,
                 color=cm.hsv(32*(i)), bottom=b2_1)
    # create bars for the extrapolated values
    bt = plt.bar(len(b1)+np.arange(len(d))+width/2, y2,
                 width=width/2, color=cm.bone(32*(i+2)),
                 bottom=b2_2)
    # update the bottom array
    b2_1 += d
    b2_2 += y2

# label the X ticks with years
plt.xticks(np.arange(len(years))+width/2,
           [int(year) for year in years])

# draw a legend, with a smaller font
plt.legend(loc='upper left',
           prop=font_manager.FontProperties(size=7))

# save & show the graph
plt.subplots_adjust(bottom=0.11, left=0.15)
plt.savefig('7900_09_06.png')
plt.show()
