{# When a server finishes deploying, run init #}       
init_sls:
  local.state.apply:
    - tgt: {{ data.id }}
    - arg:
      - init.mine

  