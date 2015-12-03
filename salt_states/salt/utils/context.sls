/var/log/salt/context:
  file.managed:
    - user: root
    - group: root
    - contents: |
        {{ show_full_context }}