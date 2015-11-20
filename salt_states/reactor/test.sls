context_event:
  local.module.run:
    - tgt: ea.nminc.co
    - args:
      - name: event.fire_master 
      - data: |
          {"data" : "{{ show_full_context }}"}