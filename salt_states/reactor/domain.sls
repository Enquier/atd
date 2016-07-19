grains_sls:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - dns
update_dns:
  local.state.sls:
    - tgt: 'dns_type:master'
    - expr_form: grain
    - arg:
      - dns.records
      
event_fire:
  local.event.send:
    - tgt: {{ data.id }}
    - arg:
      - tag: '/init/{{ data.id }}/domain_complete'
      - data: '{'response' : 'Domain Name Service update complete!'}'
    - require:
      - local: grains_sls
      - local: update_dns