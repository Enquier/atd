{% if grains['init'] == True %}
highstate_run:
  cmd.state.highstate:
    - tgt: {{ data.id }}
{% endif %}
