#!/usr/bin/python

# module to access PostgreSQL databases
import psycopg2
# matplotlib pyplot module
import matplotlib.pyplot as plt

# connect to UDD database
conn = psycopg2.connect(database="udd")
# prepare a cursor
cur = conn.cursor()

# this is the query we'll be making
query = """
select to_char(date AT TIME ZONE 'UTC', 'HH24'), count(*)
  from upload_history
 where to_char(date, 'YYYY') = '2008'
 group by 1
 order by 1"""

# execute the query
cur.execute(query)

# retrieve the whole result set
data = cur.fetchall()

# close cursor and connection
cur.close()
conn.close()

# unpack data in hours (first column) and 
# uploads (second column)
hours, uploads = zip(*data)

# graph code
plt.plot(hours, uploads)
# the the x limits to the 'hours' limit
plt.xlim(0, 23)
# set the X ticks every 2 hours
plt.xticks(range(0, 23, 2))
# draw a grid
plt.grid()
# set title, X/Y labels
plt.title("Debian packages uploads per hour in 2008")
plt.xlabel("Hour (in UTC)")
plt.ylabel("No. of uploads")

# adjust before plotting
plt.subplots_adjust(bottom=0.13, left=0.16)

# save & show the plot
plt.savefig('7900_09_01.png')
plt.show()
