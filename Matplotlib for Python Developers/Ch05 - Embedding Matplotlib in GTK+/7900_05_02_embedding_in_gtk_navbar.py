#!/usr/bin/python

# gtk module
import gtk

# matplotlib Figure object
from matplotlib.figure import Figure
# numpy functions for image creation
import numpy as np

# import the GtkAgg FigureCanvas object, that binds Figure to GTKAgg backend.
# In this case, this is a gtk.DrawingArea
from matplotlib.backends.backend_gtkagg import FigureCanvasGTKAgg as FigureCanvas
# import the NavigationToolbar GTKAgg widget
from matplotlib.backends.backend_gtkagg import NavigationToolbar2GTKAgg as NavigationToolbar

# instantiate the GTK+ window object
win = gtk.Window()
# connect the 'destroy' signal to gtk.main_quit function
win.connect("destroy", gtk.main_quit)
# define the size of the GTK+ window
win.set_default_size(600,400)
# set the window title
win.set_title("Matplotlib Figure in a GTK+ Window With NavigationToolbar")

# create a vertical container for widgets
vbox = gtk.VBox()
# and add it to the main GTK+ window
win.add(vbox)

# matplotlib code to generate the plot
fig = Figure(figsize=(5,4), dpi=100)
ax = fig.add_subplot(111)
x = np.arange(0,2*np.pi,.01)
y = np.sin(x**2)*np.exp(-x)
ax.plot(x,y)

# we bind the figure to the FigureCanvas, so that it will be drawn
# using the specific backend graphic functions
canvas = FigureCanvas(fig)
# add the Figure widget as the first one on the box container
vbox.pack_start(canvas)
# instantiate the NavigationToolbar as bind to the Figure
# and the main GTK+ window
toolbar = NavigationToolbar(canvas, win)
# add the NavigationToolbar to the box container
vbox.pack_start(toolbar, expand=False, fill=False)

# show all the widget attached to the main window
win.show_all()
# start the GTK+ main loop
gtk.main()
