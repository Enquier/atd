{% if grains['init'] == False %}
init/{{ grains['id'] }}/new:
  event.send:
    - data:
        response : "Server configuration has completed!"
{% else %}
init/{{ grains['id'] }}/existing:
  event.send:
    - data:
        response : "Server configuration has already completed!"
{% endif %}