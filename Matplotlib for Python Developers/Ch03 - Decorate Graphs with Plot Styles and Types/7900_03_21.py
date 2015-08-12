#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0, 2*np.pi, .01)
y = np.sin(x)
plt.plot(x, y)
plt.text(0.1, -0.04, 'sin(0)=0')
plt.show()