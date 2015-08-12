#!/usr/bin/python

# to read Apache log file
from __future__ import with_statement
# Numpy and matplotlib modules
import numpy as np
import matplotlib.pyplot as plt
# needed for formatting Y axis
from matplotlib.ticker import FuncFormatter
# to parse the log file
import re

def megabytes(x, pos):
    """Formatter for Y axis, values are in megabytes"""
    return '%1.f' % (x/(1024*1024))

# prepare the regular expression to match
# the day and the size of the request
apa_line = re.compile(r'.*\[([^:]+):.* ([0-9]+) .+ .+')

# prepare dictionaries to contain the data
day_hits = {}
day_txn = {}

# we open the file
with open('/var/log/apache2/access.log') as f:
    # and for every line in it
    for line in f:
        # we pass the line to regular expression
        m = apa_line.match(line)
        # and we get the 2 values matched back
        day, call_size = m.groups()

        # if the current day is already present
        if day in day_hits:
            # we add the call and the size of the request
            day_hits[day] += 1
            day_txn[day] += int(call_size)
        else:
            # else we initialize the dictionaries
            day_hits[day] = 1
            day_txn[day] = int(call_size)

# prepare a list of the keys (days)
keys = sorted(day_hits.keys())

# prepare a figure and an Axes in it
fig = plt.figure()
ax1 = fig.add_subplot(111)

# bar width
width = .4

# for each key (day) and it's position
for i, k  in enumerate(keys):
    # we plot a bar
    ax1.bar(i - width/2, day_hits[k], width=width, color='y')

# for each label for the X ticks
for label in ax1.get_xticklabels():
    # we hide it
    label.set_visible(False)

# add a label to the Y axis (for the first plot)
ax1.set_ylabel('Total hits')

# create another Axes instance, twin of the previous one
ax2 = ax1.twinx()

# plot the total requests size
ax2.plot([day_txn[k] for k in keys], 'k', linewidth=2)

# set the Y axis to start from 0
ax2.set_ylim(ymin=0)

# set the X ticks for each element of keys (days)
ax2.set_xticks(range(len(keys)))
# set the label for them to keys, rotating and align to the right
ax2.set_xticklabels(keys, rotation=25, ha='right')

# set the formatter for Y ticks labels
ax2.yaxis.set_major_formatter(FuncFormatter(megabytes))
# add a label to Y axis (for the second plot)
ax2.set_ylabel('Total transferred data (in Mb)')

# add a title to the whole plot
plt.title('Apache hits and transferred data by day')

# save & show the figure
plt.subplots_adjust(bottom=0.18)
plt.savefig('7900_09_03.png')
plt.show()
