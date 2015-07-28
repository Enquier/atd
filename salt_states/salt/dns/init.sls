{#
Salt Formula by Charles Galey cgaley@nomagic.com
Developed for NMInc
#}

{% if grains['farm_role_index'] == 1 %}

 {% set myURL = grains['nodename'] %}

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
    - name: hostnamectl set-hostname {{ myURL }}
    - user: root
    - group: root
