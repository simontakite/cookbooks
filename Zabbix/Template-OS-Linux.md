
Template OS Linux
===========


This template use the APC-POWERNET-MIB to discover and manage APC UPS devices.


Items
-----


  * Available memory
  * Checksum of $1
  * Context switches per second
  * CPU $2 time
  * CPU $2 time
  * CPU $2 time
  * CPU $2 time
  * CPU $2 time
  * CPU $2 time
  * CPU $2 time
  * CPU $2 time
  * Free swap space
  * Free swap space in %
  * Host boot time
  * Host local time
  * Host name
  * Interrupts per second
  * Maximum number of opened files
  * Maximum number of processes
  * Number of logged in users
  * Number of processes
  * Number of running processes
  * Processor load (1 min average per core)
  * Processor load (5 min average per core)
  * Processor load (15 min average per core)
  * System information
  * System uptime
  * Total memory
  * Total swap space


Triggers
-----


  * **[WARNING]** => /etc/passwd has been changed on {HOST.NAME}
  * **[INFORMATION]** => Configured max number of opened files is too low on {HOST.NAME}
  * **[INFORMATION]** => Configured max number of processes is too low on {HOST.NAME}
  * **[WARNING]** => Disk I/O is overloaded on {HOST.NAME}
  * **[INFORMATION]** => Host information was changed on {HOST.NAME}
  * **[INFORMATION]** => Hostname was changed on {HOST.NAME}
  * **[AVERAGE]** => Lack of available memory on server {HOST.NAME}
  * **[WARNING]** => Lack of free swap space on {HOST.NAME}
  * **[WARNING]** => Processor load is too high on {HOST.NAME}
  * **[WARNING]** => Too many processes on {HOST.NAME}
  * **[WARNING]** => Too many processes running on {HOST.NAME}
  * **[INFORMATION]** => {HOST.NAME} has just been restarted


Discovery rules
-----


  * Mounted filesystem discovery
  * Network interface discovery


Graphs
------


  * CPU jumps
  * CPU load
  * CPU utilization
  * Memory usage
  * Swap usage


Installation
------------


### Requirements


This template was tested for Zabbix 2.2.0


License
-------


This template is distributed under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the  License, or -at your option any- later version.


### Authors


Simon Takite
(simont |at| uninett |dot| no)


Rune Myrhaug
(rune |at| uninett |dot| no)


Bjørn Villa
(bjorn |at| uninett |dot| no)
