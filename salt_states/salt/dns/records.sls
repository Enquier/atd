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
service.enable:
  module.run
    - name: named
{% endif %}

{% if salt['service.status']('named') %}
service.reload:
  module.run:
    - name: named
{% else %}
service.start:
  module.run:
    - name: named
{% endif %}

   