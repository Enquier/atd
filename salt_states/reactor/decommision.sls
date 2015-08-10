{# Server is being terminated -- remove accepted key #}
{% if data['data']['serverstate'] == 'terminate' %}
minion_term:
  wheel.key.delete:
    - match: {{ data['id'] }}

update_dns:
  local.state.apply:
    - tgt: 'dbs_type:master'
    - expr_form: grain
    - arg:
      - dns.records
{% endif %}
