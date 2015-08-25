include: 
  - teamwork

{% if salt['service.disabled']('teamwork') %}
enable_teamwork:
  module.run:
    - name: service.enable
    - m_name: teamwork
    - require:
      - file: copy_lic_key
{% endif %}

{% if salt['service.status']('teamwork') %}
reload_teamwork:
  module.run:
    - name: service.reload
    - m_name: teamwork
    - require:
      - file: copy_lic_key
{% else %}
start_teamwork:
  module.run:
    - name: service.start
    - m_name: teamwork
    - require:
      - file: copy_lic_key
{% endif %}

copy_lic_key:
  file.managed:
    - name: /home/teamwork/.lic/{{ pillar['tw_lic'] }}
    - source: salt://teamwork/files/lic/{{ pillar['tw_lic'] }}
    - makedirs: True
    - mode: 400
    - user: teamwork
    - group: teamwork