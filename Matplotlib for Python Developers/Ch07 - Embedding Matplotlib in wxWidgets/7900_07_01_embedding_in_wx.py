#!/usr/bin/env python

# wxPython module
import wx

# Matplotlib Figure object
from matplotlib.figure import Figure
# Numpy functions for image creation
import numpy as np

# import the WxAgg FigureCanvas object, that binds Figure to
# WxAgg backend. In this case, this is a wxPanel
from matplotlib.backends.backend_wxagg import FigureCanvasWxAgg as FigureCanvas


class MplCanvasFrame(wx.Frame):
    """Class to represent a Matplotlib Figure as a wxFrame"""
    def __init__(self):
        # initialize the superclass, the wx.Frame
        wx.Frame.__init__(self, None, wx.ID_ANY,
                         title='Matplotlib in Wx', size=(600, 400))

        # usual Matplotlib functions
        self.figure = Figure(figsize=(6, 4), dpi=100)
        self.axes = self.figure.add_subplot(111)
        x = np.arange(0, 6, .01)
        y = np.sin(x**2)*np.exp(-x)
        self.axes.plot(x, y)

        # initialize the FigureCanvas, mapping the figure to 
        # the Wx backend
        self.canvas = FigureCanvas(self, wx.ID_ANY, self.figure)


# Create a wrapper wxWidgets application
app = wx.PySimpleApp()
# instantiate the Matplotlib wxFrame
frame = MplCanvasFrame()
# show it
frame.Show(True)
# start wxWidgets mainloop
app.MainLoop()
