flag_for_done:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - init.setflag

highstate_run:
  local.state.highstate:
    - tgt: {{ data.id }}
    - ret: local