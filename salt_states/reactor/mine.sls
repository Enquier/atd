{# When a server finishes deploying, run init #}       
init_sls:
  local.state.apply:
    - tgt: {{ data.name }}
    - arg:
      - init.mine

  