{% set myDomain = grains['domain'] %} 

include:
  - dns
  - dns.server

/var/named/{{ myDomain }}.zone:
  file.managed:
    - source: salt://dns/files/domain.zone
    - template: jinja
      


named:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/named.conf
      - file: /var/named/{{ myDomain }}.zone
   