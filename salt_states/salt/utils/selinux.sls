{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

selinux_pkgs:
  pkg.latest:
    - pkgs:
      - policycoreutils
      - policycoreutils-python

/etc/sysconfig/selinux:
  file.managed:
    - source: salt://utils/files/selinux.default
    - user: root
    - group: root

"setenforce permissive":
  cmd.run:
    - user: root
    - group: root