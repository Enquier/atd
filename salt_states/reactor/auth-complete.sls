{# When an server starts, run mine_set then highstate. Skips if just created #}
{% if grains['init'] == True %}
mine_set:
  local.state.apply:
    - tgt: {{ name }}
    - args:
      - init.mine

highstate_run:
  local.state.highstate:
    - tgt: {{ name }}
    - ret: local
    
{% endif %}