init:
  grains.present:
    - value: True
      
init/{{ grains['id'] }}/init_complete:
  event.send:
    - { 'name' : '{{ grains['id'] }}' }
    - require:
      - grains: init
      - cmd: salt-minion