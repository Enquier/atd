  
{% set myDomain = grains['domain'] %} 

{{ myDomain }}_records:
  file.blockreplace:
    - name: /var/named/{{ myDomain }}.zone
    - marker_start: "; START::SALT::DNS::SERVER {{ myDomain }}_records Automatically Created By SALT DO NOT EDIT"
    - marker_end: "; END::SALT::DNS::SERVER {{ myDomain }}_records Automatically Created By SALT DO NOT EDIT"
    - append_if_not_found: True
    - content: "; Resolve nameserver hostnames to IP."
    
{% for server, ip in salt.mine.get('* and not G@node_type:ns*', 'internal_ip_addrs', expr_form='compound').items() %}

{% set hostdict = salt.mine.get(server, 'grains.item', expr_form='glob').items() %}

{# log_files-{{ ip[0] }}:
  cmd.run:
    - name: |
        echo "{{ hostdict[0][1]['farm_name'] }} {{ ip }}"
#}

{{ myDomain }}_records-accumulated-{{ ip[0] }}:
   file.accumulated:
     - filename: /var/named/{{ myDomain }}.zone
     - name: {{ myDomain }}-records-accumulator
     - template: jinja
     - text: "{{ hostdict[0][1]['farm_name'] }}  IN  A {{ ip[0] }}"
     - require_in: 
       - file: {{ myDomain }}_records
     
{% endfor %}
     
   

named:
  service.running:
    - enable: True
    - reload: True
   