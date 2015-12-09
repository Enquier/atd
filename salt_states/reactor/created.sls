{# When a server finishes deploying, run init #} 
{% set event_data = received['data'] %}
init_sls:
  local.state.apply:
    - tgt: {{ event_data['name'] }}
    - arg:
      - init

grains_set:
  local.state.apply:
    - tgt: {{ event_data['name'] }}
    - require:
      - local: init_sls
    - arg:
      - init.grains

flag_set:
  grains.present:
    - tgt: {{ event_data['name'] }}
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