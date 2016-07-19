{# When a server finishes deploying, run init #}       
grains_sls:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - init.grains
