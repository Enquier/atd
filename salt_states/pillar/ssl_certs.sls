{% if grains['domain'] == 'nminc.co' %}
  ssl_cert_dir: nminc
  ssl_cert_name: STAR_nminc_co
  ssl_bundle_name: COMODOCA
{% elif grains['domain'] == 'openmbee.com' %}
  ssl_cert_dir: openmbee
  ssl_cert_name: openmbee
  ssl_bundle_name: COMODOCA
{% else %}
  ssl_cert_dir: generic
  ssl_cert_name: server
  ssl_bundle_name: DigiCertCA
{% endif %}
