{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
/etc/sysconfig/selinux:
  file.managed:
    - source: salt://utils/files/selinux.default
    - user: root
    - group: root

disable_selinux_cmd:
  cmd.run:
    - name: setenforce 0
