#!/usr/bin/python

# used to parse files more easily
from __future__ import with_statement

# Numpy module
import numpy as np

# gtk module
import gtk

# module to handle Glade ui
import gtk.glade

# matplotlib Figure object
from matplotlib.figure import Figure
# import the GtkAgg FigureCanvas object, that binds Figure to GTKAgg backend.
# In this case, this is a gtk.DrawingArea
from matplotlib.backends.backend_gtkagg import FigureCanvasGTKAgg as FigureCanvas

def parse_file(filename):
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

    return letters

def update_graph(fig_ref, ax_ref, letters_freq):
    """Updates the graph with new letters frequencies"""

    # sort the keys and the values
    k = sorted(letters_freq.keys())
    v = [letters_freq[ki] for ki in k]

    # clean the Axes
    ax_ref.clear()

    # draw a bar chart for letters and their frequencies
    # set the width to 0.5 and shift bars of 0.25, to be centered
    ax_ref.bar(np.arange(len(k))-0.25, v, width=0.5)

    # reset the X limits
    ax_ref.set_xlim(xmin=-0.25, xmax=len(k)-0.75)
    # set the X ticks & tickslabel as the letters
    ax_ref.set_xticks(range(len(k)))
    ax_ref.set_xticklabels(k)

    # enable grid only on the Y axis
    ax_ref.get_yaxis().grid(True)

    # force an image redraw
    fig_ref.canvas.draw()


class GladeEventsHandlers:
    def on_mplbutton_clicked(event):
        """callback for a click on the button"""

        update_graph(fig, ax, parse_file(entry.get_text()))

    def on_mplopenmenuitem_activate(event):
        """callback for activate on the Open menu item"""

        # create a FileChooserDialog window
        chooser = gtk.FileChooserDialog("Open..",
                      None,
                      gtk.FILE_CHOOSER_ACTION_OPEN,
                      (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                      gtk.STOCK_OPEN, gtk.RESPONSE_OK))

        chooser.set_default_response(gtk.RESPONSE_OK) 
        # execute the dialog window and get the result
        res = chooser.run()

        # if the result is a click on OK
        if res == gtk.RESPONSE_OK:
            # get the file selected and set it to the entry widget
            entry.set_text(chooser.get_filename())

        # distroy the dialog window
        chooser.destroy()

# Main

# parse glade xml file, return an object to access widgets
# contained in the glade file
win = gtk.glade.XML('7900_05_04_glade.glade', 'mplwindow')
# connect the signals with the function in GladeEventsHandlers
# class with a trick...
win.signal_autoconnect(GladeEventsHandlers.__dict__)
# commodity dictionary to easily connect destroy to gtk.main_quit()
d = {"on_mplwindow_destroy": gtk.main_quit}
win.signal_autoconnect(d)
# also connect the menu item Quit to gtk.main_quit() function
win.get_widget("mplquitmenuitem").connect("activate", gtk.main_quit)

# get the main window widget and set its title
window = win.get_widget('mplwindow')
window.set_title("Matplotlib In a Glade GUI - Count letters frequency in a file")

# matplotlib code to generate an empty Axes
# we define no dimensions for Figure because it will be
# expanded to the whole empty space on main window widget
fig = Figure()
ax = fig.add_subplot(111)

# get the mplentry widget, we will use across callback functions
entry = win.get_widget("mplentry")

# we bind the figure to the FigureCanvas, so that it will be
# drawn using the specific backend graphic functions
canvas = FigureCanvas(fig)
canvas.show()
# define dimensions of the Figure canvas
canvas.set_size_request(600, 400)

# embed the canvas into the empty area left in glade window
place = win.get_widget("mplvbox")
place.pack_start(canvas, True, True)

# start the GTK+ main loop
gtk.main()
