#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
x = np.arange(1, 5)
plt.plot(x, x*1.5, label='Normal')
plt.plot(x, x*3.0, label='Fast')
plt.plot(x, x/3.0, label='Slow')
plt.grid(True)
plt.title('Sample Growth of a Measure')
plt.xlabel('Samples')
plt.ylabel('Values Measured')
plt.legend(loc='upper left')
plt.subplots_adjust(bottom=0.13)
plt.show()