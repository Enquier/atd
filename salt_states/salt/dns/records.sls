{% set myDomain = grains['domain'] %} 
{% set reverse = grains['dns_reverse'] %}

include:
  - dns
  - dns.server
{% if grains['dns_type'] == master %}
/var/named/{{ myDomain }}.zone:
  file.managed:
    - source: salt://dns/files/domain.zone
    - template: jinja
      
/var/named/{{ reverse }}.zone:
  file.managed:
    - source: salt://dns/files/reverse.zone
    - template: jinja
{% endif %}
named:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/named.conf
      - file: /var/named/{{ myDomain }}.zone
   