{#
Salt Formula by Charles Galey cgaley@nomagic.com
Developed for NMInc
#}

{% if grains['farm_role_index'] == 1 %}

 {% set myURL = grains['nodename'] %}

{% elif grains['farm_role_index'] == 2 %}

 {% set myURL = grains['nodename']-b %}

{% endif %}

{% set myDomain = grains['domain'] %}

system:
  network.system:
    - enabled: True
    - hostname: {{ myURL }}
    - nisdomain: {{ myDomain }}
    - require_reboot: True

hostname:
  cmd.run:
    - name: hostnamectl set-hostname {{ nodename }}
    - user: root
    - group: root
