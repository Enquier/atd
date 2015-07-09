adt/salt_states/reactor
===

This is the default location for Salt Reactor state files. 

What is a reactor?
===

The salt system uses a series of events to trigger a reaction. 

All events have a *tag* This tag is used for filtering events. 

All events also contain a data structure. The structure is a dict that contains information about the event. 

Official documentation here: http://docs.saltstack.com/en/latest/topics/reactor/


Where are reactors defined?
===

Reactors are defined in the salt master configuration file. 

For best practices we place reactor definitions in the master.d directory. 

Reactor Def: /etc/salt/master.d/reactor.conf

Example Reactors: 
```
reactor:

  - 'salt/auth':
    - /srv/reactor/auth-pending.sls
  - 'salt/minion/*/start':
    - /srv/reactor/auth-complete.sls

  - 'decom':
    - /srv/reactor/decommision.sls

  - 'minion_start':
    - /srv/salt/haproxy/configure.sls
```

In the above example we have Four different reactors. For our example we will look at the "decom" reactor. 

We are matching the tag 'decom' and when the tag is triggered, the statefile "decommission.sls" will be ran. 

The absolute path for the decomission.sls file is "/srv/reactor/decommission.sls"

decommission.sls
```
{# Server is being terminated -- remove accepted key #}
{% if data['data']['serverstate'] == 'terminate' %}
minion_term:
  wheel.key.delete:
    - match: {{ data['id'] }}
{% endif %}
```

The above code will do the following. 

1. When an event.fire_master is triggered with the data "serverstate" action "terminate" and tag decom. The master will know to follow the jinja if statement. 
2. The if statement will issue the function wheel.key.delete. 
3. the wheel.key.delete will take the "id" of the minion that issues the event and will attempt to remove the minion's key from the salt-master. 

This event is triggered via scalr using the "BeforeHostTerminate" condition in the roles "orchestration". This should cause the minion to remove itself from the SaltMaster if it is terminated. 

If this fails for some reason, a scheduled task runs on the salt master (using scalr) that runs:
```
#!/bin/bash
salt-run manage.down removekeys=True
```

This is part of a script on scalr called "SCALR :: MASTER :: Check old keys"

auth-pending.sls
===

Auth-pending is a reactor that watches for the 'act' tag when a new salt-minion attempts to connect to the salt master. If the minion's ID contains a specified set of characters (such as europa/mars2020/etc...) then the minion is automatically accepted by the salt-master. 

auth-complete.sls
===

Once a system is authenticated the 'auth-complete' reactor is triggered and issues a "state.highstate" on the new minion. 

This causes the new server to automatically trigger its install and setup states that will make it into a usable system. 

A reactor that does not have a custom state file (.sls file) is the "minion_start" reactor. This listens for the minion_start event. If triggered it will re-run the haproxy.configure state that will use jinja templating to gather all hosts with "alfresco" in their ID and will add their IP addresses to the HAProxy Load Balancer farm. 

This is accomplished using jinja templating with a for statement using salt mine data as its input. See /srv/salt/haproxy/files/haproxy.config.default for an example (near the bottom of the file).  
