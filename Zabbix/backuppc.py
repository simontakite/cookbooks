from bs4 import BeautifulSoup
import urllib2
import argparse
 
backuppc = "http://10.0.0.5:8000/backuppc.html"
header = {'User-Agent': 'Mozilla/5.0'} #Needed to prevent 403 error on backuppcpedia
req = urllib2.Request(backuppc,headers=header)
page = urllib2.urlopen(req)
soup = BeautifulSoup(page)
 
def backuppchostitem(hostname, hostitem):

	tablesoup = soup.find("table", { "class" : "sortable" })

	for row in tablesoup.findAll("tr"):
		
		cell = row.findAll("td")
		host = cell[0].find(text=True)
		
		if host == hostname:

			user = cell[1].findAll(text=True)	
			full = cell[2].findAll(text=True) 	
			full_age = cell[3].findAll(text=True)  	
			full_size = cell[4].findAll(text=True)	
			speed = cell[5].findAll(text=True) 	
			incr = cell[6].findAll(text=True)
			incr_age = cell[7].findAll(text=True)  	
			last_backup = cell[8].findAll(text=True)  	
			state = cell[9].findAll(text=True)  	
			errors = cell[10].findAll(text=True)  	
			last_attempt = cell[11].findAll(text=True)  

	if hostitem == "full":
		hostitem = ''.join(full)
	if hostitem == "fullage":
		hostitem = ''.join(full_age)
	if hostitem == "fullsize":
		hostitem = ''.join(full_size)
	if hostitem == "speed":
		hostitem = ''.join(speed)
	if hostitem == "incr":
		hostitem = ''.join(incr)
	if hostitem == "incrage":
		hostitem = ''.join(incr_age)
	if hostitem == "lastbackup":
		hostitem = ''.join(last_backup)
	if hostitem == "state":
		hostitem = ''.join(state)
	if hostitem == "errors":
		hostitem = ''.join(errors)
	if hostitem == "lastattempt":
		hostitem = ''.join(last_attempt)

	print hostitem
	
	return

def main():
	parser = argparse.ArgumentParser(description='Retrieve host backuppc Page values from the backuppc Page host summary page')
	parser.add_argument('hostname',action="store", help='Hostname for the backuppc Page host')
	parser.add_argument('hostitem',action="store", help='Specifies values to be fetched from the host row e.g full, fullage, speed, incr, incrage, lastbackup, state, errors, lastattempt')
	args = parser.parse_args()
	hostname=args.hostname
	hostitem=args.hostitem
	
	backuppchostitem(hostname, hostitem)

if __name__ == "__main__":
	main()
