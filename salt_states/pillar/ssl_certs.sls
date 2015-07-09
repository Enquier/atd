{% if grains['farm_name'] == 'ems' %}
  ssl_cert_dir: ems
{% elif grains['farm_name'] == 'ems-stg' %}
  ssl_cert_dir: ems-stg
{% elif grains['farm_name'] == 'ems-test' %}
  ssl_cert_dir: ems-test
{% elif grains['farm_name'] == 'ems-int' %}
  ssl_cert_dir: ems-int
{% elif grains['farm_name'] == 'europaems' %}
  ssl_cert_dir: europaems
{% elif grains['farm_name'] == 'europaems-stg' %}
  ssl_cert_dir: europaems-stg
{% elif grains['farm_name'] == 'europaems-test' %}
  ssl_cert_dir: europaems-test
{% elif grains['farm_name'] == 'europaems-int' %}
  ssl_cert_dir: europaems-int
{% elif grains['farm_name'] == 'mmos' %}
  ssl_cert_dir: mmos
{% elif grains['farm_name'] == 'mmos-stg' %}
  ssl_cert_dir: mmos-stg
{% elif grains['farm_name'] == 'mmos-test' %}
  ssl_cert_dir: mmos-test
{% elif grains['farm_name'] == 'msmems' %}
  ssl_cert_dir: msmems
{% elif grains['farm_name'] == 'msmems-stg' %}
  ssl_cert_dir: msmems-stg
{% elif grains['farm_name'] == 'msmems-test' %}
  ssl_cert_dir: msmems-test
{% elif grains['farm_name'] == 'rn-ems' %}
  ssl_cert_dir: rn-ems
{% elif grains['farm_name'] == 'rn-ems-test' %}
  ssl_cert_dir: rn-ems-test
{% else %}
  ssl_cert_dir: generic
{% endif %}
