#!/usr/bin/env python



''' A simple disk monitoring script - Tested on Python 3.3 and Python 2.7'''

__author__ = "Muhammad Zeeshan Munir"
__copyright__ = "Copyright 2013, Muhammad Zeeshan Munir"


import subprocess,re,datetime


cmd = "df -hP |egrep ^/dev |awk '{print $6 \"  \" $5}'" #command to check disk space, pipe it to grep for filter only devices and then print the 6th and 5th coulmn.
uptime = "uptime"


'''Using python's subprocess.Popen to execute the commands in shell and generating
generator output into output.'''
def executeCmd(command):
  process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
  while (True):
    output = process.stdout.read()
    retcode = process.poll()
    yield output
    if(retcode is not None):
      break

'''Method to check system uptime and then print it on the screen'''
def chkUptime(command):
  for output in executeCmd(command):
    print(output.decode("utf-8"))
  
'''Method to infer how much disk space is left and print it on the screen with time stamp.
It can be used to send an email to sys admin with the disk space left. The default warning
level is 75 %.'''
def chkDisk(disk_name, disk_size, warn_level=75):
  time_stamp = datetime.datetime.now() #get current date and time for timestamp.
  disk_s = int(disk_size.strip('%')) #Python stip function strips '%' sign from the disk_size and then convert it into an int.
  free_disk = 100 - disk_s #100 - 80 = 20% disk space is left
  if  disk_s > warn_level:
    print(str(time_stamp) +"\t The disk " +disk_name+ " is getting full. Only "+ str(free_disk)+" % free space is left.")


  
'''This method doesn't work on Python 3.3.2 on linux, as well as on OS X but works in Python 2.7'''
def sendCmd(command):
  for output in executeCmd(command):
    disk_name, disk_size = output.split()
    chkDisk(disk_name, disk_size)

    
'''This method works on MacOS  X as well on Linux in Python 3.3.2'''
def sendCmd_Dict(command):
  for output in executeCmd(command):
    df_h = output.decode("utf-8") #if we don't decode it sends 'b' for buffer with the output
    df_h = df_h.split() #output is splitted based on new line chracters.
  #Creating a dictionary, key is disk name e.g. /, /boot, /home and values are used space in percentage e.g. 60%, 80% etc
  df_h_dict = {df_h[i]: df_h[i+1] for i in range(0, len(df_h), 2)}
  for key, value in df_h_dict.items():
    chkDisk(key, value)

    
sendCmd_Dict(cmd)
chkUptime(uptime)
