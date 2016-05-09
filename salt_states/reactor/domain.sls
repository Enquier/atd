grains_sls:
  local.state.apply:
    - tgt: {{ data.id }}
    - arg:
      - dns
update_dns:
  local.state.apply:
    - tgt: 'dns_type:master'
    - expr_form: grain
    - arg:
      - dns.records
      
event_fire:
  local.event.send:
    - tgt: {{ data.id }}
    - arg:
      - name: '/init/{{ data.id }}/domain_complete'
    - require:
      - local: grains_sls
      - local: update_dns