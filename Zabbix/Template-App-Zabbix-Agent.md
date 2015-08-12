
Template App Zabbix Agent
===========


This template use the APC-POWERNET-MIB to discover and manage APC UPS devices.


Items
-----


  * Agent ping
  * Host name of zabbix_agentd running
  * Version of zabbix_agent(d) running


Triggers
-----


  * **[INFORMATION]** => Host name of zabbix_agentd was changed on {HOST.NAME}
  * **[INFORMATION]** => Version of zabbix_agent(d) was changed on {HOST.NAME}
  * **[AVERAGE]** => Zabbix agent on {HOST.NAME} is unreachable for 5 minutes


Discovery rules
-----


  * 


Graphs
------


  * 


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
