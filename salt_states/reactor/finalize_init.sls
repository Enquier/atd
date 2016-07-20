flag_for_done:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - init.setflag

event_fire:
  local.event.send:
    - tgt: {{ data.id }}
    - arg:
      - tag: '/init/{{ data.id }}/init_complete'
      - data: "{'response' : 'Intialization Complete! Running HighState...'}"
    - require:
      - local: flag_for_done

highstate_run:
  local.state.highstate:
    - tgt: {{ data.id }}
    - ret: local
    - require:
      - local: event_fire