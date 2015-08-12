#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np

theta = np.arange(0., 2., 1./180.)*np.pi

plt.polar(3*theta, theta/5);
plt.polar(theta, np.cos(4*theta));
plt.polar(theta, [1.4]*len(theta));

plt.show()