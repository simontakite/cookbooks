#!/usr/bin/python

import matplotlib.pyplot as plt
plt.axis([0, 9, 0, 18])
arrstyles = ['-', '->', '-[', '<-', '<->', 'fancy', 'simple', 'wedge']
for i, style in enumerate(arrstyles):
    plt.annotate(style, xytext=(1, 2+2*i), xy=(4, 1+2*i),arrowprops=dict(arrowstyle=style))
connstyles=["arc", "arc,angleA=10,armA=30,rad=15", "arc3,rad=.2", "arc3,rad=-.2", "angle", "angle3"]
for i, style in enumerate(connstyles):
    plt.annotate("", xytext=(6, 4+2*i), xy=(8, 3+2*i), arrowprops=dict(arrowstyle='->', connectionstyle=style))
plt.show()