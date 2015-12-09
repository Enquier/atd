init:
  grains.present:
    - value: True

salt-minion:
  service.running:
    - name: salt-minion
    - require:
      - pkg: salt-minion
  cmd.wait:
    - name: 'echo systemctl restart salt-minion | at now + 15 seconds'
    - watch:
      - pkg: salt-minion
    - require:
      - pkg: at
      - service: at