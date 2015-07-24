base:
 '*':
   - edit
   - utils
   - utils.epel_repo
   - utils.selinux
##   - ldap
   - sshd

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
   - tomcat.build_ssl
   - build 
   - engineer.maven
   - engineer.node_js
   
   

 'node_type:allinone':
   - match: grain
#   - java
#   - utils.alfresco_deps
#   - dns
#   - activemq
#   - apache
#   - apache.mod_jk
#   - apache.enable_modjk
#   - apache.alfresco_modrewrite
#   - tomcat
#   - tomcat.setenv
#   - tomcat.apache_apr
#   - tomcat.alfresco_ssl
#   - utils.swftools
#   - database
#   - database.postgresqlREPO
#   - database.installPostgresql
#   - database.postgresqlAlfDBcreate
#   - alfresco
#   - alfresco.copy
#   - alfresco.deploy
#   - alfresco.amps_deploy
