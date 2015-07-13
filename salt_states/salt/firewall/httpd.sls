{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for MBEE/NASA Summer 2014
#}
include:
 - firewall

http_iptables_acc1:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to HTTP (TCP 80)
        -A MBEE-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
    - require_in:
        - file: salt_iptables

http_iptables_acc2:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to HTTP (TCP 443)
        -A MBEE-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
    - require_in:
        - file: salt_iptables
