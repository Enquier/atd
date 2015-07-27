base:
  '*':
    - magicdraw
    - ssl_certs
    - soapui
    - tomcat
  
  'node_type:build':
    - match: grains
    - tomcat
    - smtp

  'node_type:allinone':
    - match: grains
    - tomcat
    - smtp
