#!/usr/bin/python

# to get the web pages
import urllib2

# lxml submodule for html parsing
from lxml.html import parse

# regular expression module
import re

# Matplotlib module
import matplotlib.pyplot as plt

# general urllib2 config
user_agent = 'Mozilla/5.0 (compatible; MSIE 5.5; Windows NT)'
headers = { 'User-Agent' : user_agent }
url = "http://it.wikipedia.org/wiki/Demografia_d'Italia"

# prepare the request and open the url
req = urllib2.Request(url, headers=headers)
response = urllib2.urlopen(req)

# we parse the webpage, getroot() return the document root
doc = parse(response).getroot()

# find the data table, using css elements
table = doc.cssselect('table.wikitable')[0]

# prepare data structures, will contain actual data
years = []
people = []

# iterate over the rows of the table, except first and last ones
for row in table.cssselect('tr')[1:-1]:
    # get the row cell (we will use only the first two)
    data = row.cssselect('td')

    # the first cell is the year
    tmp_years = data[0].text_content()
    # cleanup for cases like 'YYYY[N]' (date + footnote link)
    tmp_years = re.sub('\[.\]', '', tmp_years)

    # the second cell is the population count
    tmp_people = data[1].text_content()
    # cleanup from '.', used as separator
    tmp_people = tmp_people.replace('.', '')

    # append current data to data lists, converting to integers
    years.append(int(tmp_years))
    people.append(int(tmp_people))

# plot data
plt.plot(years,people)
# ticks every 10 years
plt.xticks(range(min(years), max(years), 10))
plt.grid()
# add a note for 2001 Census
plt.annotate("2001 Census", xy=(2001, people[years.index(2001)]),
             xytext=(1986, 54.5*10**6),
             arrowprops=dict(arrowstyle='fancy'))

plt.savefig('7900_09_02.png')
plt.show()

