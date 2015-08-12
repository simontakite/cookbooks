#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
y = np.arange(1,3,0.3)
plt.plot(y, color='blue', linestyle='dashdot', linewidth=4,
         marker='o', markerfacecolor='red', markeredgecolor='black',
         markeredgewidth=3, markersize=12)
plt.show()