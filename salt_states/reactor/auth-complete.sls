{# When an server starts, run mine_set then highstate. Skips if just created #}
{% if grains['init'] == True %}
mine_set:
  local.state.apply:
    - tgt: {{ data['id'] }}
    - args:
      - init.mine

highstate_run:
  local.state.highstate:
    - tgt: {{ data['id'] }}
    - ret: local
    
{% endif %}