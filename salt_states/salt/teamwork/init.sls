{% set  md_ver = grains['MAGICDRAW_VERSION'] %}
teamwork:
  group:
    - present
    - gid: 510
  user:
    - present
    - uid: 510
    - groups: 
      - teamwork
      - wheel
    - password: 50a4c933fed8429857b0175749a6810a86e6b738 #letmeadmintw
    - require:
      - group: teamwork
    - shell: /bin/sh
    - createhome: True

teamwork_zip_deploy:
  archive.extracted:
    - name: /opt/local/teamwork-{{ md_ver }}
    - source: salt://teamwork/files/MagicDraw_{{ md_ver }}_teamwork_server_no_install.zip
    - archive_format: zip
    - onlyif: test ! -e /opt/local/teamwork/bin/teamwork_server.properties

set_permissions:
  file.directory:
    - name: /opt/local/teamwork-{{ md_ver }}
    - user: teamwork
    - group: teamwork
    - recurse:
      - user
      - group
    - require:
      - archive: teamwork_zip_deploy
    
teamwork_sym:
  file.symlink:
    - name: /opt/local/teamwork
    - target: /opt/local/teamwork-{{ md_ver }}
    - user: teamwork
    - group: teamwork
    - recurse:
      - user
      - group  
    - require:
      - user: teamwork
      - archive: teamwork_zip_deploy

replace_props:
  file.managed:
    - name: /opt/local/teamwork/bin/teamwork_server.properties
    - source: salt://teamwork/files/teamwork_server.properties.default
    - template: jinja
    - user: teamwork
    - group: teamwork
    - require:
      - archive: teamwork_zip_deploy
      - user: teamwork
      - file: teamwork_sym

replace_stop_props:
  file.managed:
    - name: /opt/local/teamwork/bin/stop_teamwork_server.properties
    - source: salt://teamwork/files/stop_teamwork_server.properties.default
    - template: jinja
    - user: teamwork
    - group: teamwork
    - require:
      - archive: teamwork_zip_deploy
      - user: teamwork
      - file: teamwork_sym

add_muserver_props:
  file.managed:
    - name: /opt/local/teamwork/data/muserver.properties
    - source: salt://teamwork/files/muserver.properties.default
    - template: jinja
    - user: teamwork
    - group: teamwork
    - require:
      - archive: teamwork_zip_deploy
      - user: teamwork
      - file: teamwork_sym

add_tw_console_props:
  file.managed:
    - name: /opt/local/teamwork/bin/teamwork_console.properties
    - source: salt://teamwork/files/teamwork_console.properties.default
    - template: jinja
    - user: teamwork
    - group: teamwork
    - require:
      - archive: teamwork_zip_deploy
      - user: teamwork
      - file: teamwork_sym
      
tw_env_vars:
  file.append:
    - name: /etc/profile.d/teamwork.sh
    - text:
      - TEAMWORK_HOME=/opt/local/teamwork
      - export TEAMWORK_HOME
      

server_execute:
  file.managed:
    - name: /opt/local/teamwork/bin/teamwork_server
    - mode: 755
    - user: teamwork
    - group: teamwork
    - require:
      - file: teamwork_sym

admin_execute:
  file.managed:
    - name: /opt/local/teamwork/bin/teamwork_administrator
    - mode: 755
    - user: teamwork
    - group: teamwork
    - require:
      - file: teamwork_sym
    
stop_execute:
  file.managed:
    - name: /opt/local/teamwork/bin/stop_teamwork_server
    - mode: 755
    - user: teamwork
    - group: teamwork
    - require:
      - file: teamwork_sym
      
console_execute:
  file.managed:
    - name: /opt/local/teamwork/bin/teamwork_console
    - mode: 755
    - user: teamwork
    - group: teamwork
    - require:
      - file: teamwork_sym

copy_service:
  file.managed:
    - name: /usr/lib/systemd/system/teamwork.service
    - order: 1
    - source: salt://teamwork/files/teamwork.service
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    
add_teamwork_systemd:
  cmd.run:
    - order: 1
    - name: systemctl daemon-reload
    - user: root
    - group: root
    - onchanges:
      - file: copy_service

    
