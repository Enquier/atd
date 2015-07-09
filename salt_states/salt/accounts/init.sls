{#
Adds accounts for tomcat and postgresql.
Sophie Wong
08/19/2014
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

postgres:
  group:
    - present
    - gid: 502
  user:
    - present
    - uid: 502
    - groups:
      - postgres
    - require:
      - group: postgres
    - shell: /bin/bash
    - fullname: PostgreSQL Server
    - home: /var/lib/pgsql
