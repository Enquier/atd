adt/salt_states/srv/salt/utils
==========

Salt formulas for utilities that all systems require. 


swftools.sls
===

This formula will copy the swftools.tar.gz to the minion system, decompress it. Then compile and install the required tools on the remote minion system. 


selinux.sls
===

Installs the default selinux policy and makes sure that it will run in "permissive" mode. Meaning that denials will be logged but not stopped. 

epel_repo.sls
===

Ensures that the epel repository will be installed on all hosts. 

alfresco_deps.sls
===

Ensures that dependencies required for alfresco to function are installed. 

python_deps.sls
===

Ensures that dependencies required for custom python modules to function are installed. 