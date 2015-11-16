{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93:
  file.managed:
    - source: salt://database/files/RPM-GPG-KEY-PGDG-93
    - user: root
    - group: root

pgdg93:
  pkgrepo.managed:
    - humanname: PostgreSQL 9.3 $releasever - $basearch
    - baseurl: http://yum.postgresql.org/9.3/redhat/rhel-$releasever-$basearch
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93
    - comments: 
        - '#repo installed with salt'

pgdg93-source:
  pkgrepo.managed:
    - humanname: PostgreSQL 9.3 $releasever - $basearch - source
    - baseurl: http://yum.postgresql.org/srpms/9.3/redhat/rhel-$releasever-$basearch
    - enabled: 0
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-93
    - comments: 
        - '#repo installed with salt'
        
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
