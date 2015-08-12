#!/usr/bin/python

import matplotlib as mpl 
import matplotlib.pyplot as plt 
mpl.rcParams['text.usetex'] = True 
import numpy as np 
x = np.arange(0.,5., .01) 
y = [np.sin(2*np.pi*xx) * np.exp(-xx) for xx in x] 
plt.plot(x, y, label=r'$\sin(2\pi x)\exp(-x)$') 
plt.plot(x, np.exp(-x), label=r'$\exp(-x)$')
plt.plot(x, -np.exp(-x), label=r'$-\exp(-x)$')
plt.title(r'$\sin(2\pi x)\exp(-x)$ with the two asymptotes $\pm\exp(-x)$') 
plt.legend()
plt.show('7900_04_12.png')
