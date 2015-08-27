include: 
  - teamwork

{% if salt['service.disabled']('teamwork') %}
enable_teamwork:
  module.run:
    - name: service.enable
    - m_name: teamwork
{% endif %}

{% if grains['TEAMWORK_LIC_INSTALLED'] == False %} 
copy_lic_key:
  file.managed:
    - name: /home/teamwork/.lic/{{ pillar['tw_lic'] }}
    - source: salt://teamwork/files/lic/{{ pillar['tw_lic'] }}
    - makedirs: True
    - mode: 400
    - user: teamwork
    - group: teamwork

rm_lock_file:
  file.absent:
    - name: /opt/local/teamwork/.lock
     
enable_lic_key:
  module.run:
    - name: nminc_install.teamwork
    - lic_dir: /home/teamwork/.lic/{{ pillar['tw_lic'] }}
    - tw_dir: /opt/local/teamwork
    - user: teamwork
    - group: teamwork
    - require:
      - file: rm_lock_file
      - file: copy_lic_key

stop_licensed_server:
  cmd.run:
    - name: /opt/local/teamwork/bin/stop_teamwork_server
    - user: teamwork
    - group: teamwork
    - require:
      - file: enable_lic_key

TEAMWORK_LIC_INSTALLED:
  grains.present:
    - value: True
      
rm_lock_file2:
  file.absent:
    - name: /opt/local/teamwork/.lock
    - require:
      - module: enable_lic_key
      
start_teamwork:
  module.run:
    - name: service.start
    - m_name: teamwork
    - require:
      - cmd: stop_licensed_server
      - file: copy_lic_key
      - file: rm_lock_file2
{% else %}

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

{% endif %}