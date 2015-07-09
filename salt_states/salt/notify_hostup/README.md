adt/salt_states/srv/salt/notify_hostup
==========

Send an email when the host is up. Only do this the first time it comes online (not reboots or state.highstate). 

init.sls
===

Places the file "Host_Already_Configured.txt" in /tmp when ran. 

If the file /tmp/Host_Already_Configured.txt exists, the script will exit and not send email. 

If the above file does not exist it will run the notifyer script and send email to the farm's owner. 

The owner is set by a global variable in the scalr farm. 

Set the variable SCALR_NOTIFY_EMAIL to the email address of the person that should recieve email when the farm is finished configuring itself.

This should only be called after ALL other states have been ran already.  
