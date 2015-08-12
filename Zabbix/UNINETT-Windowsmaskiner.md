
UNINETT Windowsmaskiner
===========


This template use the APC-POWERNET-MIB to discover and manage APC UPS devices.


Items
-----


  * Agent ping
  * Average disk read queue length
  * Average disk write queue length
  * File read bytes per second
  * File write bytes per second
  * Free memory
  * Free swap space
  * Host name of zabbix_agentd running
  * ICMP ping response time
  * Number of processes
  * Number of threads
  * Processor load (1 min average)
  * Processor load (5 min average)
  * Processor load (15 min average)
  * System information
  * System uptime
  * Total memory
  * Total swap space
  * Version of zabbix_agent(d) running


Triggers
-----


  * **[INFORMATION]** => Host information was changed on {HOST.NAME}
  * **[INFORMATION]** => Host name of zabbix_agentd was changed on {HOST.NAME}
  * **[WARNING]** => ICMP ping response too slow from {HOST.NAME}
  * **[AVERAGE]** => Lack of free memory on server {HOST.NAME}
  * **[AVERAGE]** => Lack of free swap space on {HOST.NAME}
  * **[HIGH]** => No ICMP ping response from {HOST.NAME}
  * **[HIGH]** => No ICMP ping response from {HOST.NAME}
  * **[AVERAGE]** => Processor load is too high on {HOST.NAME}
  * **[AVERAGE]** => Too many processes on {HOST.NAME}
  * **[INFORMATION]** => Version of zabbix_agent(d) was changed on {HOST.NAME}
  * **[INFORMATION]** => Zabbix agent on {HOST.NAME} is unreachable for 180 minutes
  * **[INFORMATION]** => {HOST.NAME} has just been restarted


Discovery rules
-----


  * Mounted filesystem discovery
  * Network interface discovery


Graphs
------


  * CPU load
  * Memory usage


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
