import urllib2
import re

#set url
url = raw_input("Enter website address e.g http://www.cnn.com: > ")

#concanate http://
if 'http://' in url:
    site = url
else:
    site = 'http://'+url

#connect to a URL
website = urllib2.urlopen(site)

#read html code
html = website.read()

#use re.findall to get all the links
links = re.findall('"((http|ftp)s?://.*?)"', html)

# how many links
urllinks = len(links)

print '-'*120

emailAdresses=[]
for link in links:
    #print link[0]
    try:
        htmlFile = urllib2.urlopen(link[0])
        html = htmlFile.read()
    except Exception:
        pass
    
    regexp_email = re.compile(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b',re.IGNORECASE)
    pattern = re.compile(regexp_email)
    emailAddresses = re.findall(pattern, html)           
 
#print all matches
    print emailAddresses
            
#print links

#print "-" *90
#print urllinks[]