#!/usr/local/bin/python

import socket
import ssl
import time

## Settings
### IRC
server = "irc.uninett.no"
port = 6668
channel = "#sysop"
botnick = "zbxBot2"
password = "lukket"

### Tail
#tail_files = [
#    '/tmp/file-to-tail.txt'
#]

irc_C = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #defines the socket
irc = ssl.wrap_socket(irc_C)

print "Establishing connection to [%s]" % (server)
# Connect
irc.connect((server, port))
irc.setblocking(False)
irc.send("PASS %s\n" % (password))
irc.send("USER "+ botnick +" "+ botnick +" "+ botnick +" :meLon-Test\n")
irc.send("NICK "+ botnick +"\n")
irc.send("PRIVMSG nickserv :identify %s %s\r\n" % (botnick, password))
irc.send("JOIN "+ channel +"\n")


#tail_line = []
#for i, tail in enumerate(tail_files):
#    tail_line.append('')


while True:
    time.sleep(2)
    line = "Simon tester zabbixbot... "
    irc.send("PRIVMSG %s :%s" % (channel, line))
# Tail Files
#    for i, tail in enumerate(tail_files):
#        try:
#            f = open(tail, 'r')
#            line = f.readlines()[-1]
#            f.close()
#            if tail_line[i] != line:
#                tail_line[i] = line
#                irc.send("PRIVMSG %s :%s" % (channel, line))
#        except Exception as e:
#            print "Error with file %s" % (tail)
#            print e
#
    try:
        text=irc.recv(2040)
        print text

#        Prevent Timeout
        if text.find('PING') != -1:
           irc.send('\r\n')
    except Exception:
        continue
