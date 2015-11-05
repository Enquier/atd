install_saltrepo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS 7
    - baseurl: https://repo.saltstack.com/yum/rhel7
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/SALTSTACK-GPG-KEY

/etc/pki/rpm-gpg/SALTSTACK-GPG-KEY:
  file.managed:
    - source: salt://update/files/SALTSTACK-GPG-KEY.pub
    - user: root
    - group: root
    
update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - pkgrepo: install_saltrepo
      