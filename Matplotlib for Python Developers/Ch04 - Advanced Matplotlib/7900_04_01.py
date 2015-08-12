#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0, 10, 0.1)
y = np.random.randn(len(x))
plt.plot(x, y)
plt.title('random numbers')
plt.show('7900_04_01.png')
