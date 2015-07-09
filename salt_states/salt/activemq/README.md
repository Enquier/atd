adt/salt_states/srv/salt/activemq
==========

Salt formulas for activeq that are required for EMS live synchronizations

init.sls
===

Copies over activemq files to the minion system. 

Makes sure that the /etc/init.d/activemq start/stop file is installed on the system and added to chkconfig. 

