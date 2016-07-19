init_sls:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - init.start