{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for MBEE/NASA Summer 2014
#}
include:
 - firewall

activemq_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to activemq ssl (TCP 61616)
        -A MBEE-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 61616 -j ACCEPT
    - require_in:
        - file: salt_iptables

