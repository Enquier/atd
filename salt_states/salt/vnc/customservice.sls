{% set user = grains['vnc_user'] %}
{% set group = grains['vnc_group'] %}

include: 
  - vnc

add_vnc_service:
  file.managed:
    - name: /etc/systemd/system/vncserver@:5.service
    - source: salt://teamwork/files/vncserver@:5.service.user
    - template: jinja

{% if grains['VNC_CONFIGURED'] == False %}
setup_vnc_user:
  module.run:
    - name: nminc_install.config_vnc
    - password: 'avncpassword'
    - user: {{ user }}
    - group: {{ group }}
    - require:
      - user: {{ user }}
      - group: {{ group }}

"systemctl daemon-reload":
  cmd.run:
    - user: root
    - group: root
    - require:
      - module: setup_vnc_user

"systemctl start vncserver@:5.service":
  cmd.run:
    - user: root
    - group: root
    - require:
      - cmd: "systemctl daemon-reload"
      
"systemctl enable vncserver@:5.service":
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