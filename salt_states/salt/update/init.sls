include:
  - utils.epel_repo
  
saltstack-repo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS 7
    - baseurl: https://repo.saltstack.com/yum/rhel7
    - gpgcheck: 1
    - gpgkey: https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub
    - enabled: 1

'yum clean all':
  cmd.run
    - user: root
    - group: root
    - require:
      - pkgrepo: saltstack-repo
      - pkgrepo:epel_repo_install

    
update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - cmd: 'yum clean all'
      - pkgrepo: saltstack-repo
      - pkgrepo: epel_repo_install
      