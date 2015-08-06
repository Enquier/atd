  
{% set myDomain = grains['domain'] %} 

{{ myDomain }}_records:
  file.blockreplace:
    - name: /var/named/{{ myDomain }}.zone
    - marker_start: "; START::SALT::DNS::SERVER {{ myDomain }}_records Automatically Created By SALT DO NOT EDIT"
    - marker_end: "; END::SALT::DNS::SERVER {{ myDomain }}_records Automatically Created By SALT DO NOT EDIT"
    - append_if_not_found: True
    - content: "; Resolve nameserver hostnames to IP."
    
{% for server, ip in salt.mine.get('*', 'internal_ip_addrs', expr_form='glob').items() %}

{% set hostdict = salt.mine.get('node_type:ns-slave', 'grains.item', expr_form='grain').items() %}

{% set hostname = hostdict.server %}

 {{ myDomain }}_records-accumulated1:
   file.accumulated:
     - filename: /var/named/{{ myDomain }}.zone
     - name: {{ myDomain }}-records-accumulator
     - template: jinja
     - text: "{{ hostname }}  IN  A {{ ip[0] }}"
     - require_in: 
       - file: {{ myDomain }}_records
     
{% endfor %}
     
   

named:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: set_records-accumulated1
   