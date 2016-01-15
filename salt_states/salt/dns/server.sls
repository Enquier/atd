{#
Generic DNS Server configuration created by Charles Galey
NMINC
#}

include:
  - dns

named:
  group:
    - present
    - gid: 6000
  user:
    - present
    - uid: 6000
    - groups: 
      - named
    - require:
      - group: named
    - shell: /sbin/nologin
    - createhome: False

install_bind:
  pkg.installed:
    - names:
      - bind
      - bind-utils
  
/etc/named.conf:
  file.managed:
    - source: salt://dns/files/named.conf.default
    - template: jinja
    - user: named
    - group: named
    - require:
      - user: named
    
    
/etc/named.rfc1912.zones:
  file.managed:
    - source: salt://dns/files/named.rfc1912.zones
    - template: jinja
    - user: named
    - group: named
    - require:
      - user: named

/usr/lib/systemd/system/named.service:
  file.managed:
    - order: 1
    - source: salt://dns/files/named.service
    - user: root
    - group: root
    - mode: 755