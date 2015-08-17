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
    - require:
      - group: teamwork
    - shell: /sbin/nologin
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
    - user: teamwork
    - group: teamwork
    - require:
      - user: teamwork
      - file: teamwork_sym

add_muserver_props:
  file.managed:
    - name: /opt/local/teamwork/data/muserver.properties
    - source: salt://teamwork/files/muserver.properties.default
    - user: teamwork
    - group: teamwork
    - require:
      - file: teamwork_sym
      
set_java_home:
  file.blockreplace:
    - name: /opt/local/teamwork/bin/teamwork_server_nogui.properties
    - marker_start: "#START::SALT::TEAMWORK set_java_home Created Automatically by SALT DO NOT EDIT!!"
    - marker_end: "#END::SALT::TEAMWORK set_java_home Created Automatically by SALT DO NOT EDIT!!"
    - content: "JAVA_HOME= {{ salt.cmd.run("echo $JAVA_HOME") }}"
    - require:
      - file: teamwork_sym
      - file: replace_props


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
    
stop_execute:
  file.managed:
    - name: /opt/local/teamwork/bin/stop_teamwork_server
    - mode: 755
    - user: teamwork
    - group: teamwork
    - require:
      - file: teamwork_sym

/usr/lib/systemd/system/teamwork.service:
  file.managed:
    - order: 1
    - source: salt://teamwork/files/teamwork.service
    - template: jinja
    - user: root
    - group: root
    - mode: 755
    
add_teamwork_systemd:
  cmd.run:
    - order: 1
    - name: systemctl daemon-reload && systemctl enable teamwork.service
    - user: root
    - group: root

{% if salt['service.disabled']('teamwork') %}
enable_teamwork:
  module.run:
    - name: service.enable
    - m_name: teamwork
{% endif %}

{% if salt['service.status']('teamwork') %}
reload_teamwork:
  module.run:
    - name: service.reload
    - m_name: teamwork
{% else %}
start_teamwork:
  module.run:
    - name: service.start
    - m_name: teamwork
{% endif %}


copy_lic_key:
  file.managed:
    - name: /home/teamwork/.lic/{{ pillar['tw_lic'] }}
    - source: salt://teamwork/files/lic/{{ pillar['tw_lic'] }}
    - makedirs: True
    - mode: 400
    - user: teamwork
    - group: teamwork

#enable_license
    
