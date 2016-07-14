{# When a server finishes deploying, run init #}       
init_sls:
  local.state.apply:
    - tgt: {{ name }}
    - arg:
      - init