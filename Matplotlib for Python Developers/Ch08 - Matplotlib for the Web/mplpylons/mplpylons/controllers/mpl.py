import logging

from pylons import request, response, session, tmpl_context as c
from pylons.controllers.util import abort, redirect_to

from mplpylons.lib.base import BaseController, render

log = logging.getLogger(__name__)

# select a non-GUI backend
import matplotlib
matplotlib.use('Agg')

# import Figure and FigureCanvas, we will use API
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure

# used to generate the graph
import numpy as np

# used to 'fake' file writing
from cStringIO import StringIO

class MplController(BaseController):

    def index(self):
        # do the plotting
        fig = Figure()
        canvas = FigureCanvas(fig)
        ax = fig.add_subplot(111)
        x = np.arange(-2,2,.01)
        y = x*np.sin(x**3)
        ax.plot(x, y)

        # save the figure to the StringIO object
        s = StringIO()
        canvas.print_figure(s)

        # set the content-type and the payload for the response
        response.headers['Content-Type'] = 'image/png'
        return s.getvalue()
