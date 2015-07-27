{% if grains['node_type'] = 'build' %}
  tomcat_ajp: 8019
  tomcat_ssl: 8443
  tomcat_shutdown: 8015
  tomcat_shutdown_cmd: SHUTDOWN
  tomcat_http: 8081
  tomcat_home: /opt/local/apache-tomcat
  
{% elif grains['node_type'] = 'allinone' %}
  tomcat_ajp: 8009
  tomcat_ssl: 8443
  tomcat_shutdown: 8005
  tomcat_shutdown_cmd: SHUTDOWN
  tomcat_http: 8080
  tomcat_home: /opt/local/apache-tomcat
  
{% endif %}