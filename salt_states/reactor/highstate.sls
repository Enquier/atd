{# When an server starts, run mine_set then highstate. Skips if just created #}
highstate_run:
  local.state.highstate:
    - tgt: {{ data.id }}
    - ret: local