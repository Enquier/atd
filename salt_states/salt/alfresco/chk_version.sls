{% if grains['MMS_RELEASE'] != grains['MMS_RELEASE_INSTALLED'] %}

MMS_INSTALLED:
  grains.present:
    - value: False
	
{% endif %}