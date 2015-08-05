{#

#}

{% set myDomain = grains['domain'] %}
{% set myIP = salt.network.interface_ip('eth0') %}


install_bind:
  pkg.installed:
    pkgs:
      - bind
      - bind-utils
  
/etc/named.conf:
  file.managed:
    - source: salt://dns/files/named.conf.default
    - user: root
    - group: root
    
/var/named/{{ myDomain }}.zone:
  file.managed:
    - source: salt://dns/files/{{ myDomain }}.zone
    - template: jinja
    - user: root
    - group: root
    
{% if grains['node_type'] == 'ns-master' %}    

{% set otherIP = salt.mine.get('ns2*', 'internal_ip_addrs', expr_form='pillar') %}

  set_master_transfer:
    file.blockreplace:
      - name: /etc/named.conf
      - marker_start: "// START::SALT::DNS::SERVER set_master_transfer Configured Automatically By Salt DO NOT EDIT!!"
      - marker_end: "// END::SALT::DNS::SERVER set_master_transfer Configured Automatically By Salt DO NOT EDIT!!"
      - template: jinja
      - content: allow-transfer { localhost; {{ otherIP }} }
  
  set_zones:
    file.blockreplace:
      - name: /etc/named.conf
      - marker_start: "// START::SALT::DNS::SERVER set_zones Configured Automatically By Salt DO NOT EDIT!!"
      - marker_end: "// END::SALT::DNS::SERVER set_zones Configured Automatically By Salt DO NOT EDIT!!"
      - content: |
          zone "{{ myDomain }}" IN {
                type master;
                file "{{ myDomain }}.zone";
                allow-update { none; };
          };
          
          
  set_soa:
    file.blockreplace:
      - name: /var/named/{{ myDomain }}.zone
      - marker_start: "; START::SALT::DNS::SERVER set_soa Automatically Created By SALT DO NOT EDIT"
      - marker_end: "; END::SALT::DNS::SERVER set_soa Automatically Created By SALT DO NOT EDIT"
      - template: jinja
      - content: |
          $TTL 86400
          @   IN  SOA     ns1.{{ myDomain }}. root.{{ myDomain }}. (
            2013042201  ;Serial
            3600        ;Refresh
            1800        ;Retry
            604800      ;Expire
            86400       ;Minimum TTL
          )

  set_nsips:
    file.blockreplace:
      - name: /var/named/{{ myDomain }}.zone
      - marker_start: "; START::SALT::DNS::SERVER set_nsips Automatically Created By SALT DO NOT EDIT"
      - marker_end: "; END::SALT::DNS::SERVER set_nsips Automatically Created By SALT DO NOT EDIT"
      - template: jinja
      - content: |
          ; Resolve nameserver hostnames to IP.
          ns1		IN	A		{{ myIP }}
          ns2		IN	A		{{ otherIP }}
   
{% elif grains['node_type'] == 'ns-master' %}
{% set otherIP = salt['grains.item']('ns1*')['fqdn_ip4'] %}
  
  set_zones:
    file.blockreplace:
      - name: /etc/named.conf
      - marker_start: "// START::SALT::DNS::SERVER set_zones Configured Automatically By Salt DO NOT EDIT!!"
      - marker_end: "// END::SALT::DNS::SERVER set_zones Configured Automatically By Salt DO NOT EDIT!!"
      - content: |
          zone "{{ myDomain }}" IN {
                type slave;
                masters { {{ otherIP }}; };
                file "{{ myDomain }}.zone";
          };
          
          
  set_soa:
    file.blockreplace:
      - name: /var/named/{{ myDomain }}.zone
      - marker_start: "; START::SALT::DNS::SERVER set_soa Automatically Created By SALT DO NOT EDIT"
      - marker_end: "; END::SALT::DNS::SERVER set_soa Automatically Created By SALT DO NOT EDIT"
      - template: jinja
      - content: |
          $TTL 86400
          @   IN  SOA     ns1.{{ myDomain }}. root.{{ myDomain }}. (
            2013042201  ;Serial
            3600        ;Refresh
            1800        ;Retry
            604800      ;Expire
            86400       ;Minimum TTL
          )

  set_nsips:
    file.blockreplace:
      - name: /var/named/{{ myDomain }}.zone
      - marker_start: "; START::SALT::DNS::SERVER set_nsips Automatically Created By SALT DO NOT EDIT"
      - marker_end: "; END::SALT::DNS::SERVER set_nsips Automatically Created By SALT DO NOT EDIT"
      - template: jinja
      - content: |
          ; Resolve nameserver hostnames to IP.
          ns1		IN	A		{{ otherIP }}
          ns2		IN	A		{{ myIP }}

{% endif %}

