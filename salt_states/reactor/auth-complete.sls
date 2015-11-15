{# When an server connects, run state.highstate. #}
init_sls:
  local.state.apply:
    - tgt: {{ data['id'] }}
    - arg:
      - init

grains_set:
  local.state.apply:
    - tgt: {{ data['id'] }}
    - require:
      - local: init_sls
    - arg:
      - init.grains

mine_set:
  local.state.apply:
    - tgt: {{ data['id'] }}
    - require:
      - local: grains_set
    - args:
      - init.mine

highstate_run:
  local.state.highstate:
    - tgt: {{ data['id'] }}
    - ret: local
    - require: 
      - local: mine_set

{% if grains['node_type'] != 'ns-master' %}    
update_dns:
  local.state.apply:
    - tgt: 'node_type:ns-master'
    - expr_form: grain
    - arg:
      - dns.records
    - require: 
      - local: min_set
{% endif %}