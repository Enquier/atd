{# Server is being terminated -- remove accepted key #}
{% if data['data']['serverstate'] == 'terminate' %}
minion_term:
  wheel.key.delete:
    - match: {{ data['id'] }}
{% endif %}
