adt/salt_states/srv/salt/engineer/soapui
==========


init.sls
===

Downloads the soap_ui.sh installer from sourceforge to /tmp/soap_ui.us

Installs the soapUI package and links it to /usr/bin/soapui to make sure it is in path. 

Package is installed to /opt/local/SmartBear

Note that SmartBear/soapUI uses install4j as the installer. Information on quiet installation and options:
http://resources.ej-technologies.com/install4j/help/doc/indexRedirect.html?http&&&resources.ej-technologies.com/install4j/help/doc/helptopics/installers/options.html

