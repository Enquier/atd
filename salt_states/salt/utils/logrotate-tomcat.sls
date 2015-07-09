/etc/logrotate.d/tomcat:
  file.managed:
    - source: salt://utils/files/logrotate-tomcat.default
    - user: root
    - group: root
