{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - ldap

sssd-tool:
  pkg: 
   - installed
   - name: sssd
  service:
   - name: sssd
   - running
   - enable: True
   - reload: True
   - watch:
     - file: /etc/sssd/sssd.conf

