{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
iptables:
  pkg: 
   - installed
   - name: iptables
  service:
   - name: iptables
   - running
   - enable: True
   - reload: True
   - watch:
     - file: /etc/sysconfig/iptables

/etc/sysconfig/iptables:
  file.managed:
    - source: salt://firewall/files/iptables.default
    - user: root
    - group: root
    - mode: 644


salt_iptables:
  file.blockreplace:
    - name: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - content: '# Europa Firewall Rules'

