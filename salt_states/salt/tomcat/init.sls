{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014

Modified by Sophie Wong
#}
tomcat:
  group:
    - present
    - gid: 504
  user:
    - present
    - uid: 504
    - groups: 
      - tomcat
    - require:
      - group: tomcat
    - shell: /sbin/nologin
    - createhome: False

apache_tomcat_7_startup:
  service:
    - dead
    - name: tomcat
    - enable: True
    - onlyif: test ! -e /usr/lib/systemd/system/tomcat.service
    - require:
        - file: /etc/init.d/tomcat
        - user: tomcat
        - group: tomcat

apache_tomcat7_unpack:
  archive:
    - extracted
    - name: /opt/local
    - source: salt://tomcat/files/apache-tomcat-7.0.64.tar.gz
    - archive_format: tar
    - if_missing: /opt/local/apache-tomcat/webapps

/etc/profile.d/tomcat.sh:
  file.managed:
    - contents: |
      TOMCAT_HOME=/opt/local/apache-tomcat
      export TOMCAT_HOME

tomcat_sym:
  file.symlink:
    - name: /opt/local/apache-tomcat
    - target: /opt/local/apache-tomcat-7.0.64
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group

tomcat_owner:
  file.directory:
    - name: /opt/local/apache-tomcat-7.0.64
    - user: tomcat
    - group: tomcat
    - recurse: 
      - user
      - group

{% if grains['JAVA_VERSION'] == 8 %}

/usr/lib/systemd/system/tomcat.service:
  file.managed:
    - order: 1
    - source: salt://tomcat/files/tomcat.initd_java8
    - user: root
    - group: root
    - mode: 755

{% elif grains ['JAVA_VERSION'] == 7 %}


/usr/lib/systemd/system/tomcat.service:
  file.managed:
    - order: 1
    - source: salt://tomcat/files/tomcat.initd_java7
    - user: root
    - group: root
    - mode: 755


{% endif %}


add_tomcat_systemd
  cmd.run:
    - order: 1
    - name: systemctl enable tomcat.service

{# This makes tomcat/alfresco use properties files outside of the
   exploded wars. Maybe move to alfresco?
   Sophie Wong 8/26/2014
#}
add_alfresco_shared_loader:
  module.run:
    - name: file.replace
    - path: /opt/local/apache-tomcat/conf/catalina.properties
    - pattern: shared.loader=.*$
    - repl: shared.loader=${catalina.base}/shared/classes

