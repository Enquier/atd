{% set  md_ver = grains['MAGICDRAW_VERSION'] %}
{% set new_ver = grains['MAGICDRAW_UPGRADE'] %}

#REMEMBER THAT FIREWALLD SOMEHOW GETS TURNED ON IN TEAMWORK
prereqs:
  pkg.latest:
    - names:
      - glibc
      - glibc.i686
      - libgcc
      - libgcc.i686
      
teamwork:
  group:
    - present
    - gid: 9000
  user:
    - present
    - uid: 9000
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
    - name: /opt/local/teamwork-{{ new_ver }}
    - source: salt://teamwork/files/MagicDraw_{{ new_ver }}_teamwork_server_no_install.zip
    - archive_format: zip
    - onlyif: test ! -e /opt/local/teamwork-{{ new_ver }}/bin/teamwork_server.properties

{% if md_ver != new_ver %}
rstop_teamwork:
  module.run:
    - name: service.stop
    - m_name: teamwork
{% endif %}

set_permissions:
  file.directory:
    - name: /opt/local/teamwork-{{ new_ver }}
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
    - target: /opt/local/teamwork-{{ new_ver }}
    - user: teamwork
    - group: teamwork
    - recurse:
      - user
      - group  
    - require:
      - archive: teamwork_zip_deploy
      
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

{% if md_ver != new_ver %}    
remove_new_project_file:
  file.absent:
    - name: /opt/local/teamwork-{{ new_ver }}/projects

set_proj_permissions:
  file.directory:
    - name: /opt/local/teamwork-{{ new_ver }}/projects
    - source: /opt/local/teamwork-{{ md_ver }}/projects
    - user: teamwork
    - group: teamwork
    - require:
      - file: remove_new_project_file
      
TEAMWORK_UPGRADE:
  grains.present:
    - value: True
    - require:
      - file: teamwork_sym
      - file: set_proj_permissions
{% endif %}