{# Push apache amps from successful deployment to salt-master #}
{% if data['data']['serverstate'] == 'pushFiles' %}

push_alfresco_devel_amps:
  cp.push: grains['develop_amps_path']

{% endif %}
