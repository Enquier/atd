{#
Salt Formula by Charles Galey cgaley@nomagic.com
Developed for NMInc
#}

{% set myIP = salt.network.ip_addrs('eth0', 'cidr="172.31.0.0/16"') %}

{% if grains['farm_role_index'] == 1 %}

 {% set fqdn = grains['nodename'] %}
 {% set hostname = grains['farm_name'] %}

{% endif %}

{% set myDomain = grains['domain'] %}


set_hosts:
  file.managed:
    - name: /etc/hosts
    - contents: |
        127.0.0.1       localhost
        {{ myIP[0] }}       {{ grains['farm_name'] }}.{{ myDomain }} {{ grains['farm_name'] }}

set_hostname:
  file.managed:
    - name: /etc/hostname
    - contents: "{{ grains['farm_name'] }}"
    
update_hostname:
  cmd.run:
    - name: "bash -c "hostname -F /etc/hostname""
    - user: root
    - group: root
    - require:
      - file: set_hosts
      - file: set_hostname
