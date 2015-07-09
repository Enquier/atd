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
   - name: service postgresql-9.3 initdb
   - onlyif: test ! -e /var/lib/pgsql/9.3/data/pg_hba.conf

postgresql-server:
  pkg:
   - installed
   - name: postgresql93-server
  service:
   - name: postgresql-9.3
   - running
   - enable: True
   - reload: True
   - watch:
     - file: /var/lib/pgsql/9.3/data/pg_hba.conf
     - file: /var/lib/pgsql/9.3/data/postgresql.conf

/var/lib/pgsql/9.3/data/pg_hba.conf:
  file.managed:
    - source: salt://database/files/pg_hba.conf.default
    - user: postgres
    - group: postgres
    - template: jinja

/var/lib/pgsql/9.3/data/postgresql.conf:
  file.managed:
    - source: salt://database/files/postgresql.conf.default
    - user: postgres
    - group: postgres
