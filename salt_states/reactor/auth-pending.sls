{# server faild to authenticate -- remove accepted key #}
{% if not data['result'] and data['id'].endswith('jpl.nasa.gov') %}
minion_remove:
  wheel.key.delete:
    - match: {{ data['id'] }} minion_rejoin:
  cmd.cmd.run:
    - tgt: salt
    - arg:
      - ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "{{ data['id'] }}" 'sleep 10 && /etc/init.d/salt-minion restart'
{% endif %}

{# server is sending new key -- accept this key #}
{% if 'act' in data and data['act'] == 'pend' and data['id'].endswith('europa.jpl.nasa.gov') %}
minion_add:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('ems') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('ehm') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('Europa') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('europa') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('mbee') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('rn') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('msmems') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].startswith('mmos') %}
minion_add_demofarm:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% endif %}
