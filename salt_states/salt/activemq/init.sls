{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014

Modified by Sophie Wong
#}
activemq:
  group:
    - present
    - gid: 505
  user:
    - present
    - uid: 505
    - groups: 
      - activemq
    - require:
      - group: activemq
    - shell: /sbin/nologin
    - createhome: False

apache_activemq_7_startup:
  service:
    - dead
    - name: activemq
    - enable: True
    - onlyif: test ! -e /etc/init.d/activemq
    - require:
        - file: /etc/init.d/activemq
        - user: activemq
        - group: activemq

apache_activemq7_unpack:
  archive:
    - extracted
    - name: /opt/local
    - source: salt://activemq/files/apache-activemq-5.10.0-bin.tar.gz
    - archive_format: tar
    - if_missing: /opt/local/apache-activemq/webapps

activemq_sym:
  file.symlink:
    - name: /opt/local/apache-activemq
    - target: /opt/local/apache-activemq-5.10.0
    - user: activemq
    - group: activemq
    - recurse:
      - user
      - group

activemq_owner:
  file.directory:
    - name: /opt/local/apache-activemq-5.10.0
    - user: activemq
    - group: activemq
    - recurse: 
      - user
      - group

/etc/init.d/activemq:
  file.managed:
    - order: 1
    - source: salt://activemq/files/activemq.initd
    - user: root
    - group: root
    - mode: 755

add_activemq_chkconfig:
  cmd.run:
    - order: 1
    - name: chkconfig --add activemq
