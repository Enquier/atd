dns_sls:
  local.state.sls:
    - tgt: {{ data.id }}
    - arg:
      - dns