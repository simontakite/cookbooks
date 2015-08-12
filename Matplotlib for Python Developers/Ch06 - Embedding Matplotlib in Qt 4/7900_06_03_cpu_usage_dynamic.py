#!/usr/bin/env python

# for command-line arguments
import sys

# Python Qt4 bindings for GUI objects
from PyQt4 import QtGui

# Matplotlib Figure object
from matplotlib.figure import Figure
# import the Qt4Agg FigureCanvas object, that binds Figure to
# Qt4Agg backend. It also inherits from QWidget
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg as FigureCanvas

# used to obtain CPU usage information
import psutil as p

# Total number of iterations
MAXITERS = 30

class CPUMonitor(FigureCanvas):
    """Matplotlib Figure widget to display CPU utilization"""
    def __init__(self):
        # save the current CPU information (used by updating algorithm)
        self.before = self.prepare_cpu_usage()

        # first image setup
        self.fig = Figure()
        self.ax = self.fig.add_subplot(111)

        # initialization of the canvas
        FigureCanvas.__init__(self, self.fig)

        # set specific limits for X and Y axes
        self.ax.set_xlim(0, 30)
        self.ax.set_ylim(0, 100)

        # and disable figure-wide autoscale
        self.ax.set_autoscale_on(False)

        # generates first "empty" plots
        self.user, self.nice, self.sys, self.idle = [], [], [], []

        self.l_user, = self.ax.plot([], self.user, label='User %')
        self.l_nice, = self.ax.plot([], self.nice, label='Nice %')
        self.l_sys,  = self.ax.plot([], self.sys,  label='Sys %')
        self.l_idle, = self.ax.plot([], self.idle, label='Idle %')

        # add legend to plot
        self.ax.legend()

        # force a redraw of the Figure
        self.fig.canvas.draw()

        # initialize the iteration counter
        self.cnt = 0

        # call the update method (to speed-up visualization)
        self.timerEvent(None)

        # start the timer, to trigger an event every second (= 1000 millisecs)
        self.timer = self.startTimer(1000)

    def prepare_cpu_usage(self):
        """helper function to return CPU usage info"""

        # get the CPU times using psutil module
        t = p.cpu_times()

        # return only the values we're interested in
        return [t.user, t.nice, t.system, t.idle]


    def get_cpu_usage(self):
        """Compute CPU usage comparing previous and current measurements"""

        # take the current CPU usage information
        now = self.prepare_cpu_usage()
        # compute deltas between current and previous measurements
        delta = [now[i]-self.before[i] for i in range(len(now))]
        # compute the total (needed for percentages calculation)
        total = sum(delta)
        # save the current measurement to before object
        self.before = now
        # return the percentage of CPU usage for our 4 categories
        return [(100.0*dt)/total for dt in delta]

    def timerEvent(self, evt):
        """Custom timerEvent code, called upon timer event receive"""
        # get the cpu percentage usage
        result = self.get_cpu_usage()

        # append new data to the datasets
        self.user.append(result[0])
        self.nice.append(result[1])
        self.sys.append( result[2])
        self.idle.append(result[3])

        # update lines data using the lists with new data
        self.l_user.set_data(range(len(self.user)), self.user)
        self.l_nice.set_data(range(len(self.nice)), self.nice)
        self.l_sys.set_data( range(len(self.sys)),  self.sys)
        self.l_idle.set_data(range(len(self.idle)), self.idle)

        # force a redraw of the Figure
        self.fig.canvas.draw()

        # if we've done all the iterations
        if self.cnt == MAXITERS:
            # stop the timer
            self.killTimer(self.timer)
        else:
            # else, we increment the counter
            self.cnt += 1

# create the GUI application
app = QtGui.QApplication(sys.argv)
# Create our Matplotlib widget
widget = CPUMonitor()
# set the window title
widget.setWindowTitle("30 Seconds of CPU Usage Updated in RealTime")
# show the widget
widget.show()
# start the Qt main loop execution, exiting from this script
# with the same return code of Qt application
sys.exit(app.exec_())
