{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for MBEE/NASA Summer 2014
#}
include:
 - firewall

postgresql_db_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to http haproxy (TCP 80/443)
        -A MBEE-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
        -A MBEE-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
        # Allow access to haproxy stats page. (tcp 1936)
        -A MBEE-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 1936 -j ACCEPT
    - require_in:
        - file: salt_iptables

