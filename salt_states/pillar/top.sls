base:
  '*':
    - magicdraw
    - soapui
    - ipmine
    
  'node_type:build':
    - match: grain
    - ssl_certs
    - tomcat
    - smtp

  'node_type:allinone':
    - match: grain
    - ssl_certs
    - tomcat
    - smtp
