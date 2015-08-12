#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
y = np.arange(1,3,0.3)
plt.plot(y, 'cx--', y+1, 'mo:', y+2, 'kp-.')
plt.show
()