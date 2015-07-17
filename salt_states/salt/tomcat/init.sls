{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014

Modified by Sophie Wong
#}
tomcat:
  group:
    - present
    - gid: 506
  user:
    - present
    - uid: 506
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
        - file: /usr/lib/systemd/system/tomcat.service
        - user: tomcat
        - group: tomcat

apache_tomcat7_unpack:
  archive:
    - extracted
    - name: /opt/local
    - source: salt://tomcat/files/apache-tomcat-7.0.63.tar.gz
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/local/apache-tomcat/webapps

/etc/profile.d/tomcat.sh:
  file.managed:
    - source: salt://tomcat/files/tomcat.sh
    - user: root
    - group: root
    - mode: 644

tomcat_sym:
  file.symlink:
    - name: /opt/local/apache-tomcat
    - target: /opt/local/apache-tomcat-7.0.63
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group

tomcat_owner:
  file.directory:
    - name: /opt/local/apache-tomcat-7.0.63
    - user: tomcat
    - group: tomcat
    - recurse: 
      - user
      - group

/usr/lib/systemd/system/tomcat.service:
  file.managed:
    - order: 1
    - source: salt://tomcat/files/tomcat.service
    - user: root
    - group: root
    - mode: 755

/var/run/tomcat/tomcat.pid:
  file.managed:
    - order: 1
    - user: tomcat
    - group: tomcat
    - mode: 755
    - makedirs: True

{% if grains['JAVA_VERSION'] == 8 %}

/opt/local/apache-tomcat/bin/setenv.sh:
  file.managed:
    - order: 1
    - source: salt://tomcat/files/setenv.sh_java8
    - user: root
    - group: root
    - mode: 755

{% elif grains ['JAVA_VERSION'] == 7 %}

/opt/local/apache-tomcat/bin/setenv.sh:
  file.managed:
    - order: 1
    - source: salt://tomcat/files/setenv.sh_java7
    - user: root
    - group: root
    - mode: 755

{% endif %}


add_tomcat_systemd:
  cmd.run:
    - order: 1
    - name: systemctl daemon-reload && systemctl enable tomcat.service
    - user: root
    - group: root

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

