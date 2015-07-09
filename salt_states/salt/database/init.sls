{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93:
  file.managed:
    - source: salt://database/files/RPM-GPG-KEY-PGDG-93
    - user: root
    - group: root

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
