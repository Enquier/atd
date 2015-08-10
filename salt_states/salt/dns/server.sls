{#
Generic DNS Server configuration created by Charles Galey
NMINC
#}

include:
  - dns


install_bind:
  pkg.installed:
    - names:
      - bind
      - bind-utils
  
/etc/named.conf:
  file.managed:
    - source: salt://dns/files/named.conf.default
    
    
set_trusted:
  file.blockreplace:
    - name: /etc/named.conf
    - marker_start: "// START::SALT::DNS:SERVER set_trusted Automatically Created by SALT DO NOT EDIT!"
    - marker_end: "// END::SALT::DNS:SERVER set_trusted Automatically Created by SALT DO NOT EDIT!"
    - content: |
        acl "trusted" {

{% for trusted in grains['dns_trusted'] %} 
trusted-accumulated-{{ trusted }}:
   file.accumulated:
     - filename: /etc/named.conf
     - name: trusted-accumulator
     - template: jinja
     - text: "{{ trusted }};"
     - require_in: 
       - file: set_trusted             
{% endfor %}

trusted-accumulated-end:
   file.accumulated:
     - filename: /etc/named.conf
     - name: trusted-accumulator
     - template: jinja
     - text: "};"
     - require_in: 
       - file: set_trusted