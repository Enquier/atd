adt/salt_states/srv/salt/firewall
==========

init.sls
===

Ensures that the system has iptables installed. 

This will need to be chaged for the CentOS 7x release as CentOS7x is currently using "firewalld" over iptables. 

All files listed below will require an update to detect the version of CentOS to install iptables rules or filewalld rules. 

haproxy.sls
===

This will install firewall rules required for the haproxy (load balancer) to recieve requests on port 80 and 443 (http/https). 

httpd.sls
=== 

This will install firewall rules required for port 80 and port 443 on all "alfresco" or "all-in-one" servers. This rule can be used on any server that requires port TCP 80/443 open for remote systems. 

nfs.sls
===

This enables ALL ports required for NFS mounts. 

postgresql.sls
===

This will enable the default communication ports for postgresql Database server to communicate with external systems. 

tomcat.sls
===

This will enable port 8443 for SSL secured connections to the tomcat server on the host. 

tomcat_dev.sls
===

This will enable access to port 8080 on the tomcat host. This should only be applied to development/staging/qa systems. This should NEVER be applied to a productation system. 

vnc.sls
===

This will open all ports on the host required to open a VNC session. This should ONLY be applied to a "Developer" system. This port should NEVER be active for any server used for customer access.  
