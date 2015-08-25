{% if grains['nodename'] == 'tw.nminc.co' %}
  tw_lic: tw-nminc-co.lic
{% elif grains['nodename'] == 'twpub.nminc.co' %}
  tw_lic: twpub-nminc-co.lic
{% else %}
  tw_lic: none.lic
{% endif %}
