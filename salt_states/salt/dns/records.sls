{% set myDomain = grains['domain'] %} 
{% set reverse = grains['dns_reverse'] %}

include:
  - dns
  - dns.server
{% if grains['dns_type'] == "master" %}
/var/named/{{ myDomain }}zone:
  file.managed:
    - source: salt://dns/files/domain.external.zone
    - template: jinja
    - user: named
    - group: named
    - require:
      - sls: dns.server
      
/var/named/{{ reverse }}.zone:
  file.managed:
    - source: salt://dns/files/reverse.zone
    - template: jinja
    - user: named
    - group: named
    - require:
      - sls: dns.server
{% endif %}
   
{% if salt['service.disabled']('named') %}
enable_named:
  module.run:
    - name: service.enable
    - m_name: named
    - user: named
    - group: named
    - require:
      - sls: dns.server
{% endif %}

{% if salt['service.status']('named') %}
reload_named:
  module.run:
    - name: service.reload
    - m_name: named
    - user: named
    - group: named
    - require:
      - sls: dns.server
{% else %}
start_named:
  module.run:
    - name: service.start
    - m_name: named
    - user: named
    - group: named
    - require:
      - sls: dns.server
{% endif %}

   