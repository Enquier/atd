adt/salt_states/srv/salt/haproxy
==========

Installs the HAproxy Load Balancer. 

REQUIRES! Variable "SCALR_ENABLE_LOADBALANCE" to be set to either True or False in scalr farm global variables. 

This will create the grain "ENABLE_LOADBALANCE" that is used to filter if a host should be added to the loadbalancer. 

If the value is unset or is set to False the system will NOT be added to the loadbalancer. 

init.sls
===

Makes sure the haproxy package is installed. 

Enables the haproxy service at boot and sets "/etc/haproxy/haproxy.cfg" as a "watch" file. 

configure.sls
===
Installs the default configuration for haproxy. 

This configuration uses jinja templates to generate some parts of the configuration so that a host is automatically added to the load balancer. 

start.sls
===

State that allows a haproxy restart to be triggered easily. 
