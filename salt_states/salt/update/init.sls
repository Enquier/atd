saltstack-repo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS 7
    - baseurl: https://repo.saltstack.com/yum/rhel7
    - gpgcheck: 1
    - gpgkey: https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
    - enabled: 1
    
update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - pkgrepo: saltstack-repo
      