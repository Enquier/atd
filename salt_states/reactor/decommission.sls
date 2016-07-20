{# Server is being terminated -- remove accepted key #}
{% if data.event == 'destroyed instance' %}
minion_term:
  wheel.key.delete:
    - match: {{ data.name }}

mine_sync:
  mine.update
    - tgt: 'dns_type:master'
    - expr_form: grain

update_dns:
  local.state.sls:
    - tgt: 'dns_type:master'
    - expr_form: grain
    - arg:
      - dns.records
    -require:
      - local.mine_sync
{% endif %}
