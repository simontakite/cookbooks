#!/usr/bin/python

# Numpy
import numpy as np
# Basemap
from mpl_toolkits.basemap import Basemap
# Pyplot
import matplotlib.pyplot as plt

# the map, a Miller Cylindrical projection
m = Basemap(projection='mill',
            llcrnrlon=-180. ,llcrnrlat=-60,
            urcrnrlon=180. ,urcrnrlat=80.)

# read the shapefile archive
s = m.readshapefile('../data/copper', 'copper')

# prepare map coordinate lists for copper smelters locations
x, y = zip(*m.copper)

# draw coast lines and fill the continents
m.drawcoastlines()
m.fillcontinents()

# draw a blue dot at smelters location
plt.plot(x, y, 'b.')

plt.title('World Copper Smelters Locations')

plt.savefig('7900_09_13.png')
plt.show()
