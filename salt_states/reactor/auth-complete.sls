{# When an server connects, run state.highstate. #}
grains_set:
  cmd.state.apply:
    - tgt: {{ data['id'] }}
    - arg:
      - grains

highstate_run:
  cmd.state.highstate:
    - tgt: {{ data['id'] }}
    - ret: local
    - require: 
      - cmd: grains_set

{% if grains['node_type'] != 'ns-master' %}    
update_dns:
  cmd.state.apply:
    - tgt: 'node_type:ns-master'
    - expr_form: grain
    - arg:
      - dns.records
    - require: 
      - cmd: grains_set
{% endif %}