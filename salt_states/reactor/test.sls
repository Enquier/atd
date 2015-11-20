context_event:
  local.file.managed:
    - tgt: 'farm_name: salt'
    - expr_form: grain
    - args:
      - name: /var/log/salt/context
      - user: root
      - group: root
      - content: |
          {{ show_full_context }}