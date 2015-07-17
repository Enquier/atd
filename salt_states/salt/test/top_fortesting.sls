base:
 '*':
   - edit
   - utils
   - utils.epel_repo
#   - ldap
   - sshd
 'node_type:build':
   -match: grain
   - java
   - dns
   - build
 
 
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
#   - tomcat.apache_apr
#   - utils.swftools
#   - database
#   - database.postgresqlREPO
#   - database.installPostgresql
#   - database.postgresqlAlfDBcreate
#   - alfresco
#   - alfresco.copy
#   - alfresco.deploy
#   - alfresco.amps_deploy