base:
 '*':
 #  - update
   - grains
   - edit
   - utils
   - utils.epel_repo
   - utils.python_deps
 #  - utils.selinux
##   - ldap
   - sshd
   - mine
   

 'node_type:build':
   - match: grain
   - java
   - dns
   - apache
   - apache.mod_jk
   - apache.enable_modjk
   - apache.build_modrewrite
   - tomcat
   - tomcat.apache_apr
   - tomcat.setenv
   - tomcat.server_config
   - build 
   - engineer.maven
   - engineer.node_js
   - engineer.npm.grunt
   - engineer.npm.bower
   - engineer.ruby.sass
   
   

 'node_type:allinone':
   - match: grain
   - java
   - utils.alfresco_deps
   - dns
   - ldap
   - activemq
   - apache
   - apache.mod_jk
   - apache.enable_modjk
   - apache.alfresco_modrewrite
   - tomcat
   - tomcat.setenv
   - tomcat.apache_apr
   - tomcat.server_config
   - utils.swftools
   - database
   - database.postgresqlREPO
   - database.installPostgresql
   - database.postgresqlAlfDBcreate
   - alfresco
#   - alfresco.copy
   - alfresco.deploy
   - alfresco.amps_deploy
   - alfresco.configure
   - alfresco.start
   
 'node_type:ns':
   - match: grain
   - dns
   - dns.server
   - dns.records
 
 'node_type:teamwork':
   - match: grain
   - dns
   - java
   - teamwork
  # - teamwork.config
   