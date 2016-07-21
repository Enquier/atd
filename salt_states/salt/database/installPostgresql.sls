{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - database

postgresql:
  pkg.installed:
    - pkgs:
      - postgresql93
      - postgresql93-libs
      - postgresql93-server

postgres_initdb:
  cmd.run:
   - name: /usr/pgsql-9.3/bin/postgresql93-setup initdb
   - onlyif: test ! -e /var/lib/pgsql/9.3/data/pg_hba.conf
   - require:
     - pkg: postgresql

postgresql-server:
  pkg:
   - installed
   - name: postgresql93-server
  service:
   - name: postgresql-9.3
   - running
   - user: postgres
   - group: postgres
   - enable: True
   - reload: True
   - watch:
     - file: /var/lib/pgsql/9.3/data/pg_hba.conf
     - file: /var/lib/pgsql/9.3/data/postgresql.conf
   - require:
     - user: postgres
     - group: postgres
     - cmd: postgres_initdb

/var/lib/pgsql/9.3/data/pg_hba.conf:
  file.managed:
    - source: salt://database/files/pg_hba.conf.default
    - user: postgres
    - group: postgres
    - template: jinja
    - require:
      - user: postgres
      - group: postgres
      - pkg: postgresql-server

/var/lib/pgsql/9.3/data/postgresql.conf:
  file.managed:
    - source: salt://database/files/postgresql.conf.default
    - user: postgres
    - group: postgres
    - require:
      - user: postgres
      - group: postgres
      - pkg: postgresql-server
