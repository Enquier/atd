{% set nodename = grains['id'] %}
{% set nodedict = salt.nminc_utils.strsplit(nodename,'.') %}

domain:
  grains.present:
   - value: 
   {%- for node in nodedict -%}
   {%- if not loop.first -%}
   {{ nodedict[loop.index] }}.
   {%- endif -%}
   {%- endfor %}
   
nodename:
  grains.present:
    - value: {{ nodename }}
 
farm_name:
  grains.present:
    - value: {{ nodedict[0] }}
