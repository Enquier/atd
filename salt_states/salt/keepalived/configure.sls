{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://keepalived/files/keepalived.conf.default
    - user: root
    - group: root
    - template: jinja

keepalived:
 service:
  - name: keepalived
  - running
  - watch:
    - file: /etc/keepalived/keepalived.conf

enable_nonlocal_ipbind:
  file.append:
    - name: /etc/sysctl.conf
    - text: net.ipv4.ip_nonlocal_bind = 1

enable_ipbind_setting:
  cmd.run:
    - name: sysctl -p
