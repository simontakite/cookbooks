#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
x = np.arange(-2,2,0.01)
y = np.arange(-2,2,0.01)
X, Y = np.meshgrid(x,y) 
ellipses = X*X/9 + Y*Y/4 -1
cs = plt.contour(ellipses)
plt.clabel(cs)
plt.show('7900_04_15.png')
