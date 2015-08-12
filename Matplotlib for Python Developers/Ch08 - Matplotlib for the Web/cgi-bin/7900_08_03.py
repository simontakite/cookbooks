#!/usr/bin/python

# to access standard output
import sys

# nice tracebacks in case of error
import cgitb
cgitb.enable()

# to access GET parameters
import cgi

# select a non-GUI backend
import matplotlib
matplotlib.use('Agg')

# import plotting module
import matplotlib.pyplot as plt

# access GET parameters
form = cgi.FieldStorage()
# retrieve 'data', if missing uses the default avalue
form_data = form.getfirst('data', '1,3,2,2,4')
# generate an integer data list 
data = [int(x) for x in form_data.split(',')]

# generate the plot
plt.plot(data)

# print the content type (what's the data type)
# the new line is embedded, using '\n' notation
print "Content-Type: image/png\n"

# output directly to webserver, as a png file
plt.savefig(sys.stdout, format='png')

