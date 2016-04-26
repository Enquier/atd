sync_all:
  local.saltutil.sync_all:
    - tgt: {{ data['id'] }}
    
event_fire:
  local.event.send:
    - tgt: {{ data.name }}
    - arg:
      - name: '/init/{{ data.name }}/sync_complete'
    - require:
      - local: sync_all