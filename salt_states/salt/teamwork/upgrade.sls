{% set  md_ver = grains['MAGICDRAW_VERSION'] %}
{% set new_ver = grains['MAGICDRAW_UPGRADE'] %}
  
teamwork_zip_deploy:
  archive.extracted:
    - name: /opt/local/teamwork-{{ new_ver }}
    - source: salt://teamwork/files/MagicDraw_{{ new_ver }}_teamwork_server_no_install.zip
    - archive_format: zip
    - onlyif: test ! -e /opt/local/teamwork-{{ new_ver }}/bin/teamwork_server.properties

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

rstop_teamwork:
  module.run:
    - name: service.stop
    - m_name: teamwork
    
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
      - module: rstop_teamwork
      
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

copy_project_file:
  file.copy:
    - name: /opt/local/teamwork-{{ new_ver }}/projects
    - source: /opt/local/teamwork-{{ md_ver }}/projects
    - user: root
    - group: root

set_proj_permissions:
  file.directory:
    - name: /opt/local/teamwork-{{ new_ver }}/projects
    - user: teamwork
    - group: teamwork
    - recurse:
      - teamwork
      - teamwork
    - require:
      - file: copy_project_file

TEAMWORK_LIC_INSTALLED:
  grains.present:
    - value: False
    - require:
      - file: teamwork_sym
      - file: copy_project_file

TEAMWORK_UPGRADE:
  grains.present:
    - value: True
    - require:
      - file: teamwork_sym
      - file: copy_project_file