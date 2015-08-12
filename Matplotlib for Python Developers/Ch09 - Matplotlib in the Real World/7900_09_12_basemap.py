#!/usr/bin/python

# pyplot import
import matplotlib.pyplot as plt
# Basemap import
from mpl_toolkits.basemap import Basemap

# Cities names and coordinates
cities = ['London', 'New York', 'Madrid', 'Cairo', 'Moscow',
          'Delhi', 'Dakar']
lat    = [51.507778, 40.716667, 40.4  , 30.058, 55.751667,
          28.61, 14.692778]
lon    = [-0.128056, -74,  -3.683333, 31.229, 37.617778,
          77.23, -17.446667]

# orthogonal projection of the Earth
m = Basemap(projection='ortho', lat_0=45, lon_0=10)
# draw the borders of the map
m.drawmapboundary()
# draw the coasts borders and fill the continents
m.drawcoastlines()
m.fillcontinents()

# map city coordinates to map coordinates
x, y = m(lon, lat)

# draw a red dot at cities coordinates
plt.plot(x, y, 'ro')

# for each city, 
for city, xc, yc in zip(cities, x, y):
# draw the city name in a yellow (shaded) box
    plt.text(xc+250000, yc-150000, city,
             bbox=dict(facecolor='yellow', alpha=0.5))

plt.savefig('7900_09_12.png')
plt.show()




