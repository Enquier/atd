flag_for_done:
  local.state.apply:
    - tgt: {{ data.id }}
    - arg:
      - init.setflag