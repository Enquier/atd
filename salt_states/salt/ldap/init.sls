{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
install_openldap:
  pkg.installed:
    - names:
      - openldap
      - openssh-ldap
      - openldap-devel
      - apr-util-ldap
      - sssd
      - sssd-client
      - sssd-tools

/etc/openldap/ldap.conf:
  file.managed:
    - source: salt://ldap/files/ldap.conf.default
    - user: root
    - group: root

/etc/openldap/certs:
  file.recurse:
    - source: salt://ldap/files/certs
    - user: root
    - group: root

/etc/openldap/cacerts:
  file.recurse:
    - source: salt://ldap/files/cacerts
    - user: root
    - group: root

/etc/sssd/sssd.conf:
  file.managed:
    - source: salt://ldap/files/sssd.conf.default
    - user: root
    - group: root
    - mode: 0600
