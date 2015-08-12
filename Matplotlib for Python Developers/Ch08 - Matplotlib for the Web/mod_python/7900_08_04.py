#!/usr/bin/python

# select a non-GUI backend
import matplotlib
matplotlib.use('Agg')

# import plotting module
import matplotlib.pyplot as plt

# used to 'fake' file writing
from cStringIO import StringIO

# used to generate the graph
import numpy as np

# function called by mod_python upon request on this file
def index(req):
    # clean the axes
    plt.cla()

    # generate the graph
    x = np.arange(0, 6, .01)
    plt.plot(x, np.sin(x)**3 + 0.5*np.cos(x))

    # instantiate a StringIO object
    s = StringIO()
    # and save the plot on it
    plt.savefig(s)

    # set the content-type for the respons
    req.content_type = "image/png"
    # and write the content of StringIO object
    req.write(s.getvalue())
