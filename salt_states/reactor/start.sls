{% if grains['init'] == True %}
highstate_run:
  local.state.highstate:
    - tgt: {{ data.id }}
    - ret: local
{% else %}
init_sls:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - init
{% endif %}