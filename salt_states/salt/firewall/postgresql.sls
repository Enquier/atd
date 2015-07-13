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
        # Allow access to postgresql (TCP 5432)
        -A MBEE-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 5432 -j ACCEPT
        -A MBEE-INPUT-LOCAL-ACCEPT -s 10.0.0.0/24 -p tcp -m state --state NEW -m tcp --dport 5432 -j ACCEPT
    - require_in:
        - file: salt_iptables

