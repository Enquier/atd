{# When a server finishes deploying, run init #}       
{% if grains['init'] == False %}
init_sls:
  local.state.sls:
    - tgt: {{ data.name }}
    - arg:
      - init

{% endif %}