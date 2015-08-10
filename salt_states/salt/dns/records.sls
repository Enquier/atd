{% set myDomain = grains['domain'] %} 
{% set reverse = grains['dns_reverse'] %}

include:
  - dns
  - dns.server
{% if grains['dns_type'] == "master" %}
/var/named/{{ myDomain }}.zone:
  file.managed:
    - source: salt://dns/files/domain.zone
    - template: jinja
      
/var/named/{{ reverse }}.zone:
  file.managed:
    - source: salt://dns/files/reverse.zone
    - template: jinja
{% endif %}
   
{% if salt['service.disabled']('named') %}
enable_bind:
  module.run
    - m_name: service.enable
    - name: named
{% endif %}

{% if salt['service.status']('named') %}
named:
  module.run:
    - m_name: service.restart
{% else %}
named:
  module.run:
    - m_name: service.start
{% endif %}

   