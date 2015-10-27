include: vnc

twadmin:
  group:
    - present
    - gid: 511
  user:
    - present
    - uid: 511
    - groups: 
      - teamwork
      - twadmin
    - password: 19e5b669d039ef27b8c00e35458acd011b8e891c
    - require:
      - group: teamwork
      - group: twadmin
    - createhome: True

  file.managed:
    - name: /etc/systemd/system/vncserver@:5.service
    - source: salt://vnc/files/vncserver@:5.service.teamwork

{% if grains['VNC_CONFIGURED'] = False %}
setup_teamwork_vnc:
  module.run:
    - name: nminc_install.vnc
    - password: 'avncpassword'
    - user: teamwork
    - group: teamwork
    - require:
      - user: twadmin

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