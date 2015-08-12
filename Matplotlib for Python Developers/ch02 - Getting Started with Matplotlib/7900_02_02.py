#!/usr/bin/python

import matplotlib.pyplot as plt
x = range(6) 
plt.plot(x, [x**2 for x in x])
plt.show()