adt/salt_states/srv/salt/engineer/artifactory
==========

Installs artifactory

init.sls
===

Installs artifactory from the salt master

Once installed basic maven settings (/opt/apache-maven-3.2.2/settings.xml) are set. 

tomcat server settings are also deployed to make sure that artifacotry will not interfear with a builtin tomcat server on port 8080. 
This is done in the configuration files deoployed to the host. 
