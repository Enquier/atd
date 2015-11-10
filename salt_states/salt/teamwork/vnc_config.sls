include: 
  - vnc
  - vnc.service
  - teamwork

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