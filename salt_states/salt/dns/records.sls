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
      
/var/named/{{ reverse }}.zone:
  file.managed:
    - source: salt://dns/files/reverse.zone
    - template: jinja
{% endif %}
   
{% if salt['service.disabled']('named') %}
enable_named:
  module.run:
    - name: service.enable
    - m_name: named
{% endif %}

{% if salt['service.status']('named') %}
reload_named:
  module.run:
    - name: service.reload
    - m_name: named
{% else %}
start_named:
  module.run:
    - name: service.start
    - m_name: named
{% endif %}

   