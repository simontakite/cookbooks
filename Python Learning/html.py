import urllib2
response = urllib2.urlopen('http://www.ntnu.no/')
print response.info()
html = response.read()

print "-"*120
response.close()  # best practice to close the file