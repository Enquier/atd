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


sudo salt-call event.send 'myevents/test/created' '{'tag':'myevents/test/created', 'data':{'profile': 'test', '_stamp': '2015-12-08T19:06:07.003459', 'name': 'test.nminc.co', 'instance_id': 'i-e151ec57', 'provider': 'nminc_aws:ec2', 'event': 'created instance'}}'