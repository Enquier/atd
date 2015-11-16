{# When an server finishes deploying, run init then highstate. #}
init_sls:
  local.state.apply:
    - tgt: {{ data['name'] }}
    - arg:
      - init

grains_set:
  local.state.apply:
    - tgt: {{ data['name'] }}
    - require:
      - local: init_sls
    - arg:
      - init.grains

mine_set:
  local.state.apply:
    - tgt: {{ data['name'] }}
    - require:
      - local: grains_set
    - args:
      - init.mine

highstate_run:
  local.state.highstate:
    - tgt: {{ data['name'] }}
    - ret: local
    - require: 
      - local: mine_set

{% if grains['node_type'] != 'ns-master' %}    
update_dns:
  local.state.apply:
    - tgt: 'dns_type: master'
    - expr_form: grain
    - arg:
      - dns.records
    - require: 
      - local: mine_set
{% endif %}