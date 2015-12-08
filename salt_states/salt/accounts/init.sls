{#
Adds accounts for tomcat and postgresql.
Sophie Wong
08/19/2014
#}
tomcat:
  group:
    - present
    - gid: 1000
  user:
    - present
    - uid: 1000
    - groups: 
      - tomcat
    - require:
      - group: tomcat
    - shell: /sbin/nologin
    - createhome: False

postgres:
  group:
    - present
    - gid: 2000
  user:
    - present
    - uid: 2000
    - groups:
      - postgres
    - require:
      - group: postgres
    - shell: /bin/bash
    - fullname: PostgreSQL Server
    - home: /var/lib/pgsql
