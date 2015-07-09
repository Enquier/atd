{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - firewall

vnc_iptables_acc1:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to VNC (tcp 6001:6030)
        -A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 6001:6030 -j ACCEPT
    - require_in:
        - file: salt_iptables

vnc_iptables_acc2:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to VNC (tcp 5901:5930)
        -A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 5901:5930 -j ACCEPT
    - require_in:
        - file: salt_iptables
