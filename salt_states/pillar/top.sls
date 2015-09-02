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
    - git

  'node_type:allinone':
    - match: grain
    - alfresco
    - ssl_certs
    - ldap
    - tomcat
    - smtp

  'node_type:teamwork':
    - match: grain
    - teamwork
  
  'node_type:cloud':
    - match: grain
    - schedule.backup