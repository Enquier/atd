{% if data.id == 'salt-minion' %}
highstate_run:
  cmd.state.highstate:
    - tgt: salt-minion
{% endif %}
