{% if grains['farm_name'] == 'ems' %}
  ssl_cert_dir: ems
{% else %}
  ssl_cert_dir: generic
{% endif %}
