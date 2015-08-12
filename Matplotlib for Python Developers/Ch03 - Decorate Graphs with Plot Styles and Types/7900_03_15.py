#!/usr/bin/python

import matplotlib.pyplot as plt
plt.figure(figsize=(3,3))
x = [45, 35, 20]
labels  = ['Cats', 'Dogs', 'Fishes']
plt.pie(x, labels = labels)
plt.show()