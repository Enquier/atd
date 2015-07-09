adt/salt_states/srv/salt/tomcat
==========

Salt formulas for tomcat that are required for Alfresco or other "tomcat" based applications to be deployed.  

init.sls
===

Copies over apache-tomcat files to the minion system. 

Makes sure that the /etc/init.d/tomcat start/stop file is installed on the system and added to chkconfig. 

apache_apr.sls
===

Downloads and installs the apache apr libraries. Using make with a prefix of /usr. 
All files are installed to /usr/lib and accessible to the apache-tomcat server. 


What is APR used for?
===

Apache apr allows for a more enterprise class deployment of the apache-tomcat environment. 

The APR native libaries are used for optimizations to the apache-tomcat system. 
