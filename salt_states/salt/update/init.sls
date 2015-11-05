install_saltrepo:
  pkgrepo.managed:
    - humanname: SaltStack repo for RHEL/CentOS 7
    - baseurl: https://repo.saltstack.com/yum/rhel7
    - keyurl: salt://update/files/SALTSTACK-GPG-KEY.pub
    - require:
      - file: /etc/pki/rpm-gpg/SALTSTACK-GPG-KEY.pub

/etc/pki/rpm-gpg/SALTSTACK-GPG-KEY.pub:
  file.managed:
    - source: salt://update/files/SALTSTACK-GPG-KEY.pub
    - source_hash: 
    - user: root
    - group: root
    
update_os:
  pkg.uptodate:
    - refresh: True
    - require:
      - pkgrepo: install_saltrepo
      