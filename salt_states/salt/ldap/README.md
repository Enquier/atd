adt/salt_states/srv/salt/ldap
==========

Sets many of the needed files and installs tools required for LDAP authentication (system level)

init.sls
===

Installs all of the packages required for ldap authentication and sssd. 

Sets default configurations for ldap.conf and sssd.conf

Copies over all certs and cacerts from saltmaster. 

enable_sssd.sls
===

Installs the sssd package and starts the service. 

Sets the service to start at boot and uses /etc/sssd/sssd.conf as a watch file
