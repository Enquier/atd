install_saltrepo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS 7
    - baseurl: https://repo.saltstack.com/yum/rhel7
    - keyurl: https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub


update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - pkgrepo: install_saltrepo
      