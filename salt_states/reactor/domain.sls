dns_sls:
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