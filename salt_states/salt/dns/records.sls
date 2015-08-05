include:
  - dns.server
  
{% set myDomain = grains['domain'] %} 

set_records:
  file.blockreplace:
    - name: /var/named/{{ myDomain }}.zone
    - marker_start: "; START::SALT::DNS::SERVER set_records Automatically Created By SALT DO NOT EDIT"
    - marker_end: "; END::SALT::DNS::SERVER set_records Automatically Created By SALT DO NOT EDIT"
    - template: jinja
    - content: |
        ; Resolve nameserver hostnames to IP.
        build		IN	A		{{ salt['cloud.get_instance']('build*')['privateIpAddress'] }}
        ea		IN	A		{{ salt['cloud.get_instance']('ea*')['privateIpAddress'] }}
        salt  IN  A   {{ salt['cloud.get_instance']('salt*')['privateIpAddress'] }}

named:
  service.running:
    - enable: True
    - reload: True
    - require:
      - file: /var/named/{{ myDomain }}.zone
      - file: /etc/named.conf
   