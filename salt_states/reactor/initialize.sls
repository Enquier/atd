{# When a server finishes deploying, run init #}       
{% if grains['init'] == False %}
init_sls:
  local.state.apply:
    - tgt: {{ data.name }}
    - arg:
      - init

{% endif %}