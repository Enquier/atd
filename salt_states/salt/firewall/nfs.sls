{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - firewall

nfsd_tcp_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to rpcbind
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 111 -j ACCEPT
        # Allow access to nfsd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
        # Allow access to rquotad
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 875 -j ACCEPT
        # Allow access to lockd 
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 4045 -j ACCEPT
        # Allow access to mountd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 4047 -j ACCEPT
        # Allow access to statd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 4048 -j ACCEPT
        # Allow statd outgoing
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p tcp -m state --state NEW -m tcp --dport 4049 -j ACCEPT
    - require_in:
        - file: salt_iptables

nfsd_udp_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to rpcbind 
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 111 -j ACCEPT
        # Allow access to nfsd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 2049 -j ACCEPT
        # Allow access to rquotad
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 875 -j ACCEPT
        # Allow access to lockd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 4046 -j ACCEPT
        # Allow access to mountd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 4047 -j ACCEPT
        # Allow access to statd
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 4048 -j ACCEPT
        # Allow statd outgoing
        -A JPL-INPUT-LOCAL-ACCEPT -s 128.149.18.0/24,128.149.19.0/24,128.149.124.0/24 -p udp -m state --state NEW -m udp --dport 4049 -j ACCEPT
    - require_in:
        - file: salt_iptables

