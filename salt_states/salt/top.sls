base:
 '*':
   - edit
   - utils
   - utils.epel_repo
   - utils.selinux
#   - utils.axel_get_yum
#   - mounted_dirs.cachefs # Doesn't work
#   - mounted_dirs.europa_nfs_homes 
#   - mounted_dirs.europa_nfs_alf_data # Doesn't work
#   - ldap # Ian commented out
#   - ldap.enable_sssd # Ian commented out
   - sshd

 'node_type:basic':
   - match: grain
   - utils.alfresco_deps
   - apache
   - apache.mod_jk
   - apache.enable_modjk
   - apache.alfresco_modrewrite
   - tomcat
   - tomcat.apache_apr
   - firewall
   - firewall.scalr_salt
   - firewall.httpd
   - firewall.tomcat
   - firewall.tomcat_dev

 'node_type:alfresco':
   - match: grain
#   - accounts
   - utils.alfresco_deps
   - activemq
   - apache
   - apache.mod_jk
   - apache.enable_modjk
   - apache.alfresco_modrewrite
   - tomcat
   - tomcat.apache_apr
   - utils.swftools
   - java
   - firewall
   - firewall.scalr_salt
   - firewall.httpd
   - firewall.tomcat
   - firewall.tomcat_dev
   - firewall.MagicDrawTeamwork
   - firewall.nfs
   - firewall.jms
   - alfresco
   - alfresco.copy
   - alfresco.deploy
   - alfresco.configure
   - alfresco.amps_deploy
#   - alfresco.decompress_war
   - alfresco.branding
#   - alfresco.start
   - sleep
   - alfresco.disable_ldap_sync
   - notify_hostup

 'node_type:db*':
   - match: grain
#   - accounts
   - database
   - database.postgresqlREPO
   - database.installPostgresql
   - database.postgresqlAlfDBcreate
   - firewall
   - firewall.scalr_salt
   - firewall.postgresql
   - notify_hostup


 'node_type:allinone':
   - match: grain
#   - accounts
{% if grains['MMS_RELEASE_INSTALLED'] == False or grains['MMS_RELEASE_INSTALLED'] == false %}
#   - mounted_dirs.europa_nfs_homes 
   - java
   - utils.alfresco_deps
#   - utils.logrotate-tomcat
   - activemq
   - apache
   - apache.mod_jk
   - apache.enable_modjk
   - apache.alfresco_modrewrite
   - tomcat
   - tomcat.apache_apr
   - utils.swftools
   - database
   - database.postgresqlREPO
   - database.installPostgresql
   - database.postgresqlAlfDBcreate
   - firewall
   - firewall.scalr_salt
   - firewall.httpd
   - firewall.tomcat
   - firewall.tomcat_dev
   - firewall.postgresql
#   - firewall.nfs
   - firewall.jms
#   - engineer.x2go
   - alfresco
   - alfresco.copy
   - alfresco.deploy
   - alfresco.amps_deploy
   - alfresco.configure
   - alfresco.branding
   - alfresco.start
   - sleep
   - alfresco.disable_ldap_sync
   - notify_hostup
   - alfresco.set_mms_release_grain
{% endif %}

 'node_type:allinone_research_network':
   - match: grain
#   - accounts
   - java
   - utils.alfresco_deps
   - apache
   - apache.mod_jk
   - apache.enable_modjk
   - apache.alfresco_modrewrite
   - tomcat
   - tomcat.apache_apr
   - utils.swftools
   - database
   - database.postgresqlREPO
   - database.installPostgresql
   - database.postgresqlAlfDBcreate
   - firewall
   - firewall.scalr_salt
   - firewall.httpd
   - firewall.tomcat
   - firewall.tomcat_dev
   - firewall.postgresql
   - firewall.nfs
   - firewall.jms
#   - engineer.x2go
   - alfresco
#   - alfresco.copy
   - alfresco.deploy
   - alfresco.configure
   - alfresco.amps_deploy
   - alfresco.decompress_war
   - alfresco.branding
   - alfresco.start
   - sleep
   - alfresco.disable_ldap_sync
   - notify_hostup


 'node_type:loadbalancer':
   - match: grain
   - haproxy
   - haproxy.configure
   - firewall
   - firewall.scalr_salt
   - firewall.haproxy
   - notify_hostup

{#   - keepalived #}
{#   - keepalived.configure #}

engineer:

 'node_type:engineer':
   - match: grain
#   - accounts
#   - mounted_dirs.europa_nfs_homes 
   - firewall
   - firewall.scalr_salt
   - firewall.httpd
   - firewall.tomcat
   - firewall.tomcat_dev
   - firewall.MagicDrawTeamwork
   - firewall.nfs
   - firewall.vnc
   - git
   - java_openjdk
   - libreoffice
   - desktops
   - x2go
   - vnc
   - vnc.msfonts
   - utils
   - utils.update_mavenOpts
   - npm
   - npm.bower
   - npm.grunt
   - npm.nodeclipse
   - eclipse
   - eclipse.atlassian_jira_plugin
   - eclipse.freemarker_ide_plugin
   - eclipse.jadclipse_plugin
   - eclipse.jrebel_plugin
   - eclipse.m2e_plugin
   - eclipse.pydev_plugin
   - eclipse.scala_plugin
   - evince_pdf
   - firefox
   - python
   - python.pip
   - python.pip_requests
   - ruby
   - ruby.sass
   - soapui
   - maven
   - artifactory
   - oxygenxml
   - apache_ant
   - evolution
   - magicdraw
   - magicdraw.smat
   - notify_hostup

 'node_type:engineer_research_network':
   - match: grain
   - firewall
   - firewall.scalr_salt
   - firewall.httpd
   - firewall.tomcat
   - firewall.tomcat_dev
   - firewall.MagicDrawTeamwork
   - firewall.nfs
   - firewall.vnc
   - git
   - java_openjdk
   - libreoffice
   - desktops
   - x2go
   - vnc
   - vnc.msfonts
   - utils
   - utils.update_mavenOpts
   - npm
   - npm.nodeclipse
   - npm.bower
   - npm.grunt
   - eclipse
   - eclipse.atlassian_jira_plugin
   - eclipse.freemarker_ide_plugin
   - eclipse.jadclipse_plugin
   - eclipse.jrebel_plugin
   - eclipse.m2e_plugin
   - eclipse.pydev_plugin
   - eclipse.scala_plugin
   - evince_pdf
   - firefox
   - python
   - python.pip
   - python.pip_requests
   - ruby
   - ruby.sass
   - soapui
   - maven
   - artifactory
   - oxygenxml
   - apache_ant
   - evolution
   - magicdraw
   - notify_hostup

