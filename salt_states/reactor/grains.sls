{# When a server finishes deploying, run init #}       
grains_sls:
  local.state.apply:
    - tgt: {{ data.id }}
    - arg:
      - init.grains
