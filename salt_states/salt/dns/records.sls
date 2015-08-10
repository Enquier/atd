{% set myDomain = grains['domain'] %} 
{% set name = grains['farm_name'] %}

include:
  - dns
  - dns.server

/var/named/{{ myDomain }}.zone:
  file.managed:
    - source: salt://dns/files/domain.zone
    - template: jinja
    
{% if grains['dns_type'] == 'master' %}    

{% set masterhost = name %}

{% elif grains['dns_type'] == 'slave' %}

{% set masterdict = salt.mine.get('G@dns_type:master', 'grains.item', expr_form='glob').items() %}
{% set masterhost = masterdict[0][1]['farm_name'] %}
          
{% endif %}  

{{ myDomain }}_ns:
  file.blockreplace:
    - name: /var/named/{{ myDomain }}.zone
    - marker_start: "; START::SALT::DNS::RECORDS {{ myDomain }}_ns Automatically Created By SALT DO NOT EDIT"
    - marker_end: "; END::SALT::DNS::RECORDS {{ myDomain }}_ns Automatically Created By SALT DO NOT EDIT"
    - content: "; Resolve nameserver hostnames."

{% for ns, host in salt.mine.get('node_type:ns', 'grains.item', expr_form='grain').items() %}
      
{{ myDomain }}_ns-accumulated-{{ ns }}:
   file.accumulated:
     - filename: /var/named/{{ myDomain }}.zone
     - name: {{ myDomain }}-records-accumulator
     - template: jinja
     - text: |
         		IN	NS		{{ host['farm_name'] }}.{{ myDomain }}
     - require_in: 
       - file: {{ myDomain }}_ns              
{% endfor %}

{{ myDomain }}_records:
  file.blockreplace:
    - name: /var/named/{{ myDomain }}.zone
    - marker_start: "; START::SALT::DNS::RECORDS {{ myDomain }}_records Automatically Created By SALT DO NOT EDIT"
    - marker_end: "; END::SALT::DNS::RECORDS {{ myDomain }}_records Automatically Created By SALT DO NOT EDIT"
    - append_if_not_found: True
    - content: "; Resolve nameserver hostnames to IP."
    
{% for server, ip in salt.mine.get('*', 'internal_ip_addrs', expr_form='glob').items() %}

{% set hostdict = salt.mine.get(server, 'grains.item', expr_form='glob').items() %}

{{ myDomain }}_records-accumulated-{{ server }}:
   file.accumulated:
     - filename: /var/named/{{ myDomain }}.zone
     - name: {{ myDomain }}-records-accumulator
     - template: jinja
     - text: "{{ hostdict[0][1]['farm_name'] }}		IN	A		{{ ip[0] }}"
     - require_in: 
       - file: {{ myDomain }}_records
     
{% endfor %}

named:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /etc/named.conf
      - file: {{ myDomain }}_records
      - file: {{ myDomain }}_ns
   