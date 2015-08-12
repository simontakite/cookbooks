#!/usr/bin/python

# for file opening made easier
from __future__ import with_statement
# numpy
import numpy as np
# matplotlib plotting module
import matplotlib.pyplot as plt
# matplotlib colormap module
import matplotlib.cm as cm
# needed for formatting Y axis
from matplotlib.ticker import FuncFormatter
# Matplotlib font manager
import matplotlib.font_manager as font_manager


def billions(x, pos):
    """Formatter for Y axis, values are in billions"""
    return '%1.fbn' % (x*1e-6)

# bar width
width = .8

# open CSV file
with open('../data/population.csv') as f:
    # read the first line, splitting the years
    years = map(int, f.readline().split(',')[1:])

    # we prepare the dtype for exacting data; it's made of:
    # <1 string field> <len(years) integers fields>
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

# prepare the bottom array
bottom = np.zeros(len(years))

# for each line in data
for i in range(len(data)):
    # create the bars for each element, on top of the previous bars
    bt = plt.bar(range(len(data[i])), data[i], width=width,
                 color=cm.hsv(32*(i)), label=continents[i],
                 bottom=bottom)
    # update the bottom array
    bottom += data[i]

# label the X ticks with years
plt.xticks(np.arange(len(years))+width/2,
           [int(year) for year in years])

# some information on the plot
plt.xlabel('Years')
plt.ylabel('Population (in billions)')
plt.title('World Population: 1950 - 2050 (predictions)')

# draw a legend, with a smaller font
plt.legend(loc='upper left',
           prop=font_manager.FontProperties(size=7))

# apply the custom function as Y axis formatter
plt.gca().yaxis.set_major_formatter(FuncFormatter(billions))

plt.subplots_adjust(bottom=0.11, left=0.15)
plt.savefig('7900_09_04.png')
plt.show()
