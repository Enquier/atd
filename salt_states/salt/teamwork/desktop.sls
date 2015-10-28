include: 
  - vnc
  - teamwork

add_vnc_service:
  file.managed:
    - name: /etc/systemd/system/vncserver@:5.service
    - source: salt://teamwork/files/vncserver@:5.service.teamwork

{% if grains['VNC_CONFIGURED'] == False %}
setup_teamwork_vnc:
  module.run:
    - name: nminc_install.vnc
    - password: 'avncpassword'
    - user: teamwork
    - group: teamwork
    - require:
      - user: teamwork

"systemctl daemon-reload"
  cmd.run:
    - user: root
    - group: root
    - require:
      - module: setup_teamwork_vnc

"systemctl start vncserver@:5.service"
  cmd.run:
    - user: root
    - group: root
    - require:
      - cmd: "systemctl daemon-reload"
      
"systemctl enable vncserver@:5.service"
  cmd.run:
    - user: root
    - group: root
    - require:
      - cmd: "systemctl start vncserver@:5.service"
           
VNC_CONFIGURED:
  grains.present:
    - value: True
    - require:
      - cmd: "systemctl enable vncserver@:5.service"
{% endif %}

add_admin_desktop:
  file.managed:
    - name: /home/teamwork/Desktop/teamwork_administrator.desktop
    - source: salt://teamwork/files/teamwork_administrator.desktop
    - user: teamwork
    - group: teamwork
    - mode: 0755
    - template: jinja

add_server_desktop:
  file.managed:
    - name: /home/teamwork/Desktop/teamwork_server.desktop
    - source: salt://teamwork/files/teamwork_server.desktop
    - user: teamwork
    - group: teamwork
    - mode: 0755
    - template: jinja    
    
add_stop_desktop:
  file.managed:
    - name: /home/teamwork/Desktop/stop_teamwork_server.desktop
    - source: salt://teamwork/files/stop_teamwork_server.desktop
    - user: teamwork
    - group: teamwork
    - mode: 0755
    - template: jinja
    
/opt/local/teamwork/bin/md.png:
  file.managed:
    - source: salt://teamwork/files/md.png
    - user: teamwork
    - group: teamwork