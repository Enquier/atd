{#
Salt Formula by Charles Galey cgaley@nomagic.com
Developed for NMInc
#}
{% set nodename = grains['id'] %}

set_hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://dns/files/hosts.default
    - template: jinja
        
set_hostname:
  file.managed:
    - name: /etc/hostname
    - source: salt://dns/files/hostname.default
    - template: jinja

update_hostname:
  cmd.run:
    - name: "hostname -F /etc/hostname"
    - user: root
    - group: root
    - require:
      - file: set_hosts
      - file: set_hostname

update_hostnamectl:
  cmd.run:
    - name: "hostnamectl set-hostname {{ grains['farm_name'] }}"
    - user: root
    - group: root
    - require:
      - file: set_hosts
      - file: set_hostname

{% if grains['init']== False %}      
/init/{{ nodename }}/domain_complete:
  event.send:
    - data:
      - response: "Domain Name Service update complete!"
    - require:
      - local: dns_sls
      - local: update_dns
{% endif %}