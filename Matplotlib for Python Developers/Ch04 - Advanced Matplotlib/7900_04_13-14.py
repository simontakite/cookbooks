#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
matr = np.random.rand(21,31)
cs = plt.contour(matr)
plt.savefig('7900_04_13.png')
csf = plt.contourf(matr)
plt.colorbar()
plt.show('7900_04_14.png')
