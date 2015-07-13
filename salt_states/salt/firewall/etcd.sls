include:
 - firewall

etcd_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow access to etcd
        -A MBEE-INPUT-LOCAL-ACCEPT -s 128.149.16.0/24 -p tcp -m state --state NEW -m tcp --dport 4001 -j ACCEPT
        -A MBEE-INPUT-LOCAL-ACCEPT -s 128.149.16.0/24 -p tcp -m state --state NEW -m tcp --dport 7001 -j ACCEPT
    - require_in:
        - file: salt_iptables

