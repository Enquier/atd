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
    - template: jinja