{% if grains['os'] == 'Amazon' %}
{% set rhel = 6 %}
{% elif grains['os'] == 'CentOS' %}
{% set rhel = grains['osmajorrelease'] %}
{% endif %}

include:
  - utils
  - utils.epel_repo
 
saltstack-repo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS {{ rhel }}
    - baseurl: https://repo.saltstack.com/yum/rhel{{ rhel }}
    - gpgcheck: 1
    - gpgkey: https://repo.saltstack.com/yum/rhel{{ rhel }}/SALTSTACK-GPG-KEY.pub
    - enabled: 1

'yum clean all':
  cmd.run:
    - user: root
    - group: root
    - require:
      - pkgrepo: saltstack-repo
      - pkgrepo: epel_repo_install

salt-minion:
  pkg.installed:
    - name: salt-minion
    - version: 2015.8.8-2.el{{ rhel }}
    - order: last
    - require:
      - pkgrepo: saltstack-repo
      - pkgrepo: epel_repo_install
  service.running:
    - name: salt-minion
    - require:
      - pkg: salt-minion
  cmd.wait:
    - name: 'echo systemctl restart salt-minion | at now + 10 minutes'
    - watch:
      - pkg: salt-minion
    - require:
      - pkg: at
      - service: at

fix_minion:
  file.replace:
    - name: /etc/salt/minion
    - pattern: 'master_type:standard'
    - repl: 'master_type:str'
    
update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - cmd: 'yum clean all'
      - pkg: salt-minion
      
      