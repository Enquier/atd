{% set  prev_ver = grains['MAGICDRAW_VERSION'] %}
{% set md_ver = grains['MAGICDRAW_UPGRADE'] %}
  
teamwork_zip_deploy:
  archive.extracted:
    - name: /opt/local/teamwork-{{ md_ver }}
    - source: salt://teamwork/files/MagicDraw_{{ md_ver }}_teamwork_server_no_install.zip
    - archive_format: zip
    - onlyif: test ! -e /opt/local/teamwork-{{ md_ver }}/bin/teamwork_server.properties

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

rstop_teamwork:
  module.run:
    - name: service.stop
    - m_name: teamwork
    
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
    - name: /opt/local/teamwork-{{ md_ver }}/projects
    - source: /opt/local/teamwork-{{ prev_ver }}/projects
    - user: teamwork
    - group: teamwork
      
MAGICDRAW_VERSION:
  grains.present:
    - value: {{ md_ver }}
    - require:
      - file: teamwork_sym
      - file: copy_project_file

TEAMWORK_LIC_INSTALLED:
  grains.present:
    - value: False
    - require:
      - file: teamwork_sym
      - file: copy_project_file