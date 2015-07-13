adt/salt_states/srv/salt/keepalived
==========

Keepalived allows for a heartbeat between two or more hosts to allow a system to bind to an IP address if the primary host serving that IP address fails. 

Ideally this would be used with the HAproxy Load balancer to make the load balancer High-Availablity and resiliant to failure. 

This is currently not in use as it requires a 3rd non-bound IP address for the two systems being watched. This is currently not possible in aws as we do not have access to elastic IP's. 

init.sls
===

Install keepalived from yum repository. 

configure.sls
===

Install basic configuration for keepalived. This uses jinja templates to auto generate some values

Enables the net.ipv4.ip_nonlocal_bind commmand and issues sysctl -p. This lets a system bind to an ip address that is not on its NIC. 
