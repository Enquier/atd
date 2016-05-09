/etc/salt/minion.d/mine.conf:
  file.managed:
    - source: salt://init/files/mine.conf
    
init/{{ grains['id'] }}/mine_complete:
  event.send:
    - data:
        response : "Mine configuration has completed!"
    - require:
      - file: /etc/salt/minion.d/mine.conf