{# When an server already exists, run highstate. #}

highstate_run:
  local.state.highstate:
    - tgt: {{ data.id }}
    - ret: local
    