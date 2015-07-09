{#
Open ports for Scalr and SaltStack
#}
include:
  - firewall

scalr_salt_iptables:
  file.accumulated:
    - name: iptables-accum1
    - filename: /etc/sysconfig/iptables
    - marker_start: '## START :: SALT :: Firewall Rules. Do not edit Manually'
    - marker_end: '## END :: SALT :: Firewall Rules. Do not edit Manually'
    - text: |
        # Allow Scalr and SaltStack
        -A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 8008:8014 -j ACCEPT
        -A JPL-INPUT-LOCAL-ACCEPT -p udp -m state --state NEW -m udp --dport 8013:8014 -j ACCEPT
        -A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 4505:4506 -j ACCEPT
    - require_in:
        - file: salt_iptables
