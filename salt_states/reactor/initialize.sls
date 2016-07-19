{# When a server finishes deploying, run init #}       
init_sls:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - init