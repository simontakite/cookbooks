#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
data1=10*np.random.rand(5)
data2=10*np.random.rand(5)
data3=10*np.random.rand(5)
e2 = 0.5 * np.abs(np.random.randn(len(data2)))
locs = np.arange(1, len(data1)+1)
width = 0.27
plt.bar(locs, data1, width=width)
plt.bar(locs+width, data2, yerr=e2, width=width, color='red')
plt.bar(locs+2*width, data3, width=width, color='green')
plt.xticks(locs + width*1.5, locs)
#plt.show()
plt.show()