#!/usr/bin/python

import matplotlib.pyplot as plt
x = range(1, 5) 

plt.plot(x, [1.5*xi for xi in x])
plt.plot(x, [3.0*xi for xi in x])
plt.plot(x, [xi/3.0 for xi in x])
plt.show()
