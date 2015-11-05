SECURITY GROUPS
==========
These are the recommended AWS security groups, cross reference these from the config files for the various servers availible
name | IPGROUP | port1;port2
ALL= 0.0.0.0/0
LOCAL= {VPC CDIR + YOUR LOCAL NET (if connected via VPN/Physical connection}

salt-master-internal | LOCAL | 4505:4506 #Internal salt master connections	
salt-minion-internal | LOCAL | 4505:4506 #Internal connection for Salt Minions
alfresco-external | ALL |	80;8080;8443;8009(localhost only);443 #Allow external connections to alfresco tomcat and webserver	
alfresco-internal | LOCAL | 80;8080;8443;8009(localhost only);443 	#Internal Alfresco deployments	
artifactory-internal | LOCAL | 8019;8015(localhost only);8443;8081	#Allow internal connections with artifactory	
cedw-external | ALL | 7000;3579;8111 #Externally facing CEDW installation	
cedw-internal | LOCAL | 7000;3579;8111 #Internal-only CEDW server
httpd-internal	| LOCAL | 80;443 #allow internal apache connections	
icmp-all	| ALL | ICMP #Allow all icmp connections
icmp-internal	| LOCAL | ICMP #Allow internal ICMP traffic	
jms-external	| ALL | 61616 #Allow Internet connections to jms
jms-internal	| LOCAL | 61616 #Internal connections to JMS
nameserver-internal| LOCAL | UDP/TCP 53 #Internal DNS Requests
postgresql-internal	| LOCAL | 5432 #Internal Postgresql connections
ssh-external | LOCAL | 22	External Connections allowed for SSH
ssh-internal | LOCAL | 22	SSH Internal only connections
teamwork-external		| ALL | 18201 External Facing teamwork
teamwork-internal		| LOCAL | 18201 Internal Teamwork Server

CONFIG FILES
==========
