{# When an server connects, run state.highstate. #}
highstate_run:
  cmd.state.highstate:
    - tgt: {{ data['id'] }}
    - ret: local
    
update_dns:
  local.state.apply:
    - tgt: 'dbs_type:master'
    - expr_form: grain
    - arg:
      - dns.records