{#
Disable the LDAP sync on alfresco startup.

We want to sync on first startup of alfresco, but not on subsequent restarts
because the syncs can take a long time to run. Sync are run after the first
sync via a cron instead.

SW 8/28/2014
#}
include:
 - alfresco

disable_sync:
  module.run:
    - name: file.replace
    - path: /opt/local/apache-tomcat/shared/classes/alfresco-global.properties
    - pattern: synchronization.syncOnStartup=true
    - repl: synchronization.syncOnStartup=false

