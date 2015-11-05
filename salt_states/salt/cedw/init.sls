{% set  md_ver = grains['MAGICDRAW_VERSION'] %}
cedw:
  group:
    - present
    - gid: 510
  user:
    - present
    - uid: 510
    - groups: 
      - cedw
      - wheel
    - password: 50a4c933fed8429857b0175749a6810a86e6b738 #letmeadmintw
    - require:
      - group: cedw
    - shell: /bin/sh
    - createhome: True

cedw_zip_deploy:
  archive.extracted:
    - name: /opt/local/cedw-{{ md_ver }}
    - source: salt://cedw/files/cedw_182_no_install_linux.gtk.x86_64.zip
    - archive_format: zip
    - onlyif: test ! -e /opt/local/cedw/CameoEnterpriseDataWarehouse/cedw.ini
    
set_permissions:
  file.directory:
    - name: /opt/local/cedw-{{ md_ver }}
    - user: cedw
    - group: cedw
    - recurse:
      - user
      - group
    - require:
      - archive: cedw_zip_deploy
    
cedw_sym:
  file.symlink:
    - name: /opt/local/cedw
    - target: /opt/local/cedw-{{ md_ver }}
    - user: cedw
    - group: cedw
    - recurse:
      - user
      - group  
    - require:
      - user: cedw
      - archive: cedw_zip_deploy

replace_props:
  file.managed:
    - name: /opt/local/cedw/CameoEnterpriseDataWarehouse/cedw.ini
    - source: salt://cedw/files/cedw.ini
    - template: jinja
    - user: cedw
    - group: cedw
    - require:
      - archive: cedw_zip_deploy
      - user: cedw
      - file: cedw_sym
      
cedw_env_vars:
  file.append:
    - name: /etc/profile.d/cedw.sh
    - text:
      - CEDW_HOME=/opt/local/cedw/CameoEnterpriseDataWarehouse/
      - export CEDW_HOME
    
