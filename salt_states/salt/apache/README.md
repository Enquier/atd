adt/salt_states/srv/salt/apache
==========

Installs apache, mod_ssl, mod_jk. Modifies revelant configuration files to enable mod_jk for apache-tomcat connector.

init.sls
===

Makes sure the Apache/HTTPD and mod_ssl are installed to the host. 

Sets the httpd service to be on at boot and starts the service. 
Sets the "httpd.conf", "ssl.conf", and workers.properties files as "watched files".

Copies over default httpd.conf, ssl.conf, workers.properties files. 

mod_jk.sls
===

Copies over the mod_jk.tar.gz file from the salt master. 

Installs the build deps. for mod_jk. 

Runs the make and install of mod_jk.so for apache. 

enable_modjk.so
===

Modifies the httpd.conf to add in required configuration settings for mod_jk.so

Also modifies ssl.conf to add mount points for alfresco and share applications under https (served by apache via mod_jk). 

alfresco_modrewrite.sls
===

Modifies httpd.conf to enable an automatic redirect from / to /share/page for the host. 
