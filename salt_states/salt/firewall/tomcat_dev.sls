{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - firewall
  - firewall.httpd
  - firewall.tomcat

tomcat_dev_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to Tomcat Dev Port (TCP 8080)
        -A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT
    - require_in:
        - file: salt_iptables

