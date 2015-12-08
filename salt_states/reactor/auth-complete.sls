{# When an server finishes deploying, run init then highstate. #}
{% if grains['init'] == False %}
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

flag_set:
  grains.present:
    - tgt: {{ data['id'] }}
    - args:
      - init.setflag
    - require:
      - local: mine_set

{% endif %}

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

highstate_run:
  local.state.highstate:
    - tgt: {{ data['id'] }}
    - ret: local