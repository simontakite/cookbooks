#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
y = np.arange(1,3)
plt.plot(y, '--', y+1, '-.', y+2, ':')
plt.show()