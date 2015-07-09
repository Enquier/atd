{% if data['data']['ampPath'] == 'setWorspace' %}
set_grain_workspace:
  grains.setval:
  - key:  develop_amps_path
  - val: {{ data['ampPath'] }}

{% endif %}

