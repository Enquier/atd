{% if grains['id'] == 'tw.nminc.co' %}
  tw_lic: tw-nminc-co-{{ grains['MAGICDRAW_UPGRADE'] }}'.lic
{% elif grains['id'] == 'twpub.nminc.co' %}
  tw_lic: twpub-nminc-co.lic
{% elif grains['id'] == 'twpub1.nminc.co' %}
  tw_lic: twpub-nminc-co.lic
{% elif grains['id'] == 'testtw.nminc.co' %}
  tw_lic: twpub-nminc-co.lic
{% else %}
  tw_lic: none.lic
{% endif %}
