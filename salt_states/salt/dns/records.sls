  
{% set myDomain = grains['domain'] %} 

set_records:
  file.blockreplace:
    - name: /var/named/{{ myDomain }}.zone
    - marker_start: "; START::SALT::DNS::SERVER set_records Automatically Created By SALT DO NOT EDIT"
    - marker_end: "; END::SALT::DNS::SERVER set_records Automatically Created By SALT DO NOT EDIT"
    - append_if_not_found: True
    - content: "; Resolve nameserver hostnames to IP."
    
{% for server, ip in salt.mine.get('*', 'internal_ip_addrs', expr_form='grain').items() %}

{% set hostdict = salt.mine.get('node_type:ns-slave', 'grains.item', expr_form='grain').items() %}

{% set hostname = hostdict.server %}

 set_records-accumulated1:
   file.accumulated:
     - filename: /var/named/{{ myDomain }}.zone
     - name: set_records
     - template: jinja
     - text: "{{ hostname }}  IN  A {{ ip[0] }}"
     - require_in: 
       - file: set_records
     
{% endfor %}
     
   

named:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: set_records-accumulated1
   