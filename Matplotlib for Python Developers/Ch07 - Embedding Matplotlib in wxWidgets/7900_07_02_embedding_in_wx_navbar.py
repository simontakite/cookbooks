#!/usr/bin/env python

# wxPython module
import wx

# Matplotlib Figure object
from matplotlib.figure import Figure
# Numpy functions for image creation
import numpy as np

# import the WxAgg FigureCanvas object, that binds Figure to
# WxAgg backend. In this case, this is also a wxPanel
from matplotlib.backends.backend_wxagg import FigureCanvasWxAgg as FigureCanvas
# import the NavigationToolbar WxAgg widget
from matplotlib.backends.backend_wx import NavigationToolbar2Wx


class MplCanvasFrame(wx.Frame):
    """Class to represent a Matplotlib Figure as a wxFrame"""
    def __init__(self):
        wx.Frame.__init__(self, None, wx.ID_ANY,
                         title='Matplotlib Figure with Navigation Toolbar', size=(600, 400))

        # usual Matplotlib functions
        self.figure = Figure()
        self.axes = self.figure.add_subplot(111)
        x = np.arange(0, 6, .01)
        y = np.sin(x**2)*np.exp(-x)
        self.axes.plot(x, y)

        # initialize the FigureCanvas, mapping the figure to 
        # the WxAgg backend
        self.canvas = FigureCanvas(self, wx.ID_ANY, self.figure)

        # create an BoxSizer, to define the layout of our window
        self.sizer = wx.BoxSizer(wx.VERTICAL)
        # add the figure canvas
        self.sizer.Add(self.canvas, 1, wx.LEFT | wx.TOP | wx.EXPAND)

        # instantiate the Navigation Toolbar
        self.toolbar = NavigationToolbar2Wx(self.canvas)
        # needed to support Windows systems
        self.toolbar.Realize()
        # add it to the sizer
        self.sizer.Add(self.toolbar, 0, wx.LEFT | wx.EXPAND)
        # explicitly show the toolbar
        self.toolbar.Show()

        # sets the window to have the given layout sizer
        self.SetSizer(self.sizer)
        # adapt sub-widget sizes to fit the window size,
        # following sizer specification
        self.Fit()

class MplApp(wx.App):
    """Define customized wxApp for MplCanvasFrame"""
    def OnInit(self):
        # instantiate our custom wxFrame
        frame = MplCanvasFrame()
        # set it at the top-level window
        self.SetTopWindow(frame)
        # show it
        frame.Show(True)
        # return True to continue processing
        return True

# we instantiate our wxApp class
mplapp = MplApp(False)
# and start the main loop
mplapp.MainLoop()
