{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - firewall

tomcat_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to tomcat ssl (TCP 8443)
        -A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 8443 -j ACCEPT
    - require_in:
        - file: salt_iptables

