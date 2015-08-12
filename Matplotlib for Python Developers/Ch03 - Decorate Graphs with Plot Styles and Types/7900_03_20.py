#!/usr/bin/python

import matplotlib.pyplot as plt
import numpy as np
theta = np.arange(0., 2., 1./180.)*np.pi
r = np.abs(np.sin(5*theta)-2.*np.cos(theta))
plt.polar(theta, r)
plt.thetagrids(range(45, 360, 90))
plt.rgrids(np.arange(0.2, 3.1, .7), angle=0)
plt.show()