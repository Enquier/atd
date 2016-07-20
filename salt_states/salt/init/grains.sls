{% set nodename = grains['id'] %}
{% set nodedict = salt.nminc_utils.strsplit(nodename,'.') %}

domain:
  grains.present:
   - value: {% for node in nodedict %}{% if not loop.first %}{{ nodedict[loop.index0] }}.{% endif %}{% endfor %}
   
nodename:
  grains.present:
    - value: {{ nodename }}
 
farm_name:
  grains.present:
    - value: {{ nodedict[0] }}
      
init/{{ nodename }}/grains_complete:
  event.send:
    - data: 
        response: "Grains setup and population has completed!"
    - require:
      - grains: farm_name
      - grains: nodename
      - grains: domain