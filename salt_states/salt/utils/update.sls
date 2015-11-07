include:
  - utils
  - utils.epel_repo
  
saltstack-repo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS 7
    - baseurl: https://repo.saltstack.com/yum/rhel7
    - gpgcheck: 1
    - gpgkey: https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
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
    - version: 2015.8.1-1.el7
    - order: last
    - require:
      - pkgrepo: saltstack-repo
      - pkgrepo: epel_repo_install
  service.running:
    - name: salt-minion
    - require:
      - pkg: salt-minion
  cmd.wait:
    - name: 'echo systemctl restart salt-minion | at now + 1 minute'
    - watch:
      - pkg: salt-minion
    - require:
      - pkg: at
      - service: at

fix_minion:
  file.replace:
    - path: /etc/salt/minion
    - pattern: 'master_type:standard'
    - repl: ''
    
update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - cmd: 'yum clean all'
      - pkg: salt-minion
      
      