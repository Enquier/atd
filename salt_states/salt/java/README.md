adt/salt_states/srv/salt/java
==========

init.sls
===

Downloads and installs jdk1.8.0_05 to all minion systems that require the Oracle Java installed for working (Alfresco uses this). 

Sets the JAVA_HOME and JRE_HOME environmental variables using /etc/profile on the target system. 

JAVA_VERSION Grain is set on bootstrap. 

This is gathered from the farm variable of "SCALR_JAVA_VERSION". Valid settings are either 7 or 8. 

This will install the proper version of java to the host. It will also modify the tomcat init script to enable MaxPermGen settings for java if using version 7. 
