adt/salt_states/srv/salt/engineer/oxygenxml
==========

Installs the OxygenXML system and connects it to the local license server.

init.sls
===

Downloads the oxygen-64big.sh file from the salt-master. 

Executes the install file using the -q -console settings to make sure it installs quietly and without prompts. 

Adds /usr/bin/oxygen to path to make it easier to launch. 


