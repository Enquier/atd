/var/log/salt/context:
  file.managed:
    - user: root
    - group: root
    - source: salt://utils/files/context
    - template: jinja