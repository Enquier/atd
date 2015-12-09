{# Server is being terminated -- remove accepted key #}
{% if data.event == 'destroyed instance' %}
minion_term:
  wheel.key.delete:
    - match: {{ data.name }}

update_dns:
  local.state.apply:
    - tgt: 'dns_type:master'
    - expr_form: grain
    - arg:
      - dns.records
{% endif %}
