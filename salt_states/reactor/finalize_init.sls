flag_for_done:
  local.state.apply:
    - tgt: {{ data.name }}
    - arg:
      - init.setflag