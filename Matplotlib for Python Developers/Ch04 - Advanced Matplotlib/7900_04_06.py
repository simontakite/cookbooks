#!/usr/bin/python

import matplotlib as mpl
mpl.rcParams['font.size'] = 4.

import matplotlib.pyplot as plt
import numpy as np
x = np.arange(0., 20, 0.01)
fig = plt.figure()
ax1 = fig.add_subplot(311)
y1 = np.exp(x/6.)
ax1.plot(x, y1)
ax1.grid(True)
ax1.set_yscale('log')
ax1.set_ylabel('log Y')
ax2 = fig.add_subplot(312)
y2 = np.cos(np.pi*x)
ax2.semilogx(x, y2)
ax2.set_xlim([0,20])
ax2.grid(True)
ax2.set_ylabel('log X')
ax3 = fig.add_subplot(313)
y3 = np.exp(x/4.)
ax3.loglog(x, y3, basex=3)
ax3.grid(True)
ax3.set_ylabel('log X and Y')
plt.show('7900_04_06.png')
