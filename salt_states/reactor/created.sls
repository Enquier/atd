{# When a server finishes deploying, run init #} 
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

flag_set:
  grains.present:
    - tgt: {{ data['name'] }}
    - args:
      - init.setflag
    - require:
      - local: mine_set

{% if grains['node_type'] != 'ns' %}    
update_dns:
  local.state.apply:
    - tgt: 'dns_type:master'
    - expr_form: grain
    - arg:
      - dns.records
    - require: 
      - local: mine_set
{% endif %}


