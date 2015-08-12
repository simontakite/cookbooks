#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np

y = np.random.randn(1000)

plt.hist(y)
plt.savefig('7900_03_07.png')

plt.clf()
plt.hist(y, 25)
plt.show()