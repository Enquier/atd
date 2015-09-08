copy_key:
  file.managed:
    - name: /home/{{ pillar['git_user'] }}/.ssh/{{ pillar['git_key'] }}
    - source: salt://git/files/{{ pillar['git_key'] }}
    - mode: 600
    - user: {{ pillar['git_user'] }}
    - group: {{ pillar['git_group'] }}

add_passphrase:
  module.run:
    - name: nminc_install.gen_expect
    - m_name: |
        sudo -su tomcat ssh-agent sh -c "ssh-add /home/{{ pillar['git_user'] }}/.ssh/{{ pillar['git_key'] }}"
    - pattern: |
        Enter passphrase for key '/home/{{ pillar['git_user'] }}/.ssh/{{ pillar['git_key'] }}'
    - response: '{{ pillar['git_passphrase'] }}'
    - user: {{ pillar['git_user'] }}
    - group: {{ pillar['git_group'] }}

  