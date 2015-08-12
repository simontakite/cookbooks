#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0, 4, 0.2)
y = np.exp(-x)
e1 = 0.1 * np.abs(np.random.randn(len(y)))
plt.errorbar(x, y, yerr=e1, fmt='.-')
plt.savefig('7900_03_09.png')
plt.clf()
e2 = 0.1 * np.abs(np.random.randn(len(y)))
plt.errorbar(x, y, yerr=e1, xerr=e2, fmt='.-', capsize=0)
plt.savefig('7900_03_10.png')
plt.clf()
plt.errorbar(x, y, yerr=[e1,e2], fmt='.-')
plt.show()

