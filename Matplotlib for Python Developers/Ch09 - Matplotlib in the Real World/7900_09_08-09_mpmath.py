#!/usr/bin/python

# import mpmath module
import mpmath as mp

# trick to show & save with the same function:
# if file is None, it shows the plot, else it saves to the filename
for file in [None, '7900_09_08.png']:
    # plot a sine between -6 and 6
    mp.plot(mp.sin, [-6, 6], file=file)

# same trick as above
for file in [None, '7900_09_09.png']:
    # plot square root (to show complex plotting)
    # and a custom function (made with lambda expression)
    mp.plot([mp.sqrt, lambda x: -0.1*x**3 + x-0.5], [-3, 3],
            file=file)
