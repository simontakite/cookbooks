# -*- coding: utf-8 -*-
# generated by wxGlade 0.6.3 on Wed Jun 24 20:00:54 2009

from __future__ import with_statement

import wx

# begin wxGlade: dependencies
# end wxGlade

# begin wxGlade: extracode

# end wxGlade

# Matplotlib Figure object
from matplotlib.figure import Figure
# Numpy module
import numpy as np

# import the WxAgg FigureCanvas object, that binds Figure to
# WxAgg backend. In this case, this is a wxPanel
from matplotlib.backends.backend_wxagg import FigureCanvasWxAgg as FigureCanvas

class MplPanel(wx.Panel):
    def __init__(self, *args, **kwds):
        # begin wxGlade: MplPanel.__init__
        wx.Panel.__init__(self, *args, **kwds)

        self.__set_properties()
        self.__do_layout()
        # end wxGlade

        # Matplotlib code to setup Figure and Axes
        self.figure = Figure(figsize=(6, 4), dpi=100)
        self.axes = self.figure.add_subplot(111)

        # we bind the figure to the FigureCanvas, so that it will
        # be drawn using the specific backend 
        self.canvas = FigureCanvas(self, wx.ID_ANY, self.figure)

    def __set_properties(self):
        # begin wxGlade: MplPanel.__set_properties
        pass
        # end wxGlade

    def __do_layout(self):
        # begin wxGlade: MplPanel.__do_layout
        pass
        # end wxGlade

    def parse_file(self, filename):
        """Function to parse a text file to extract letters frequencies"""

        # dict initialization
        letters = {}

        # lower-case letter ordinal numbers
        for i in range(97, 122 + 1):
            letters[chr(i)] = 0

        # parse the input file
        with open(filename) as f:
            for line in f:
                for char in line:
                    # counts only letters
                    if ord(char.lower()) in range(97, 122 + 1):
                        letters[char.lower()] += 1

        # returns an ordered list of letters and
        # their relative counts in the file
        return sorted(letters.keys()), [letters[k] for k in sorted(letters.keys())]

    def update_graph(self, filename):
        """Updates the graph with new letters frequencies"""

        # get letters (l) and counting values (v) from file
        l, v = self.parse_file(filename)

        # clear the Axes
        self.axes.clear()

        # draw a bar chart for letters and their frequencies
        # set the width to 0.5 and shift bars of 0.25, to be centered
        self.axes.bar(np.arange(len(l))-0.25, v, width=0.5)
        # reset the X limits
        self.axes.set_xlim(xmin=-0.25, xmax=len(l)-0.75)
        # set the X ticks & tickslabel as the letters
        self.axes.set_xticks(range(len(l)))
        self.axes.set_xticklabels(l)
        # enable grid only on the Y axis
        self.axes.get_yaxis().grid(True)
        # force an image redraw
        self.figure.canvas.draw()

# end of class MplPanel


