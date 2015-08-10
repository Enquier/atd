{# server faild to authenticate -- remove accepted key #}
{% if not data['result'] and ( data['id'].endswith('nminc.co') or data['id'].endswith('openmbee.com') ) %}
minion_remove:
  wheel.key.delete:
    - match: {{ data['id'] }} minion_rejoin:
  cmd.cmd.run:
    - tgt: salt
    - arg:
      - ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "{{ data['id'] }}" 'sleep 10 && /etc/init.d/salt-minion restart'
{% endif %}

{# server is sending new key -- accept this key #}
{% if 'act' in data and data['act'] == 'pend' and data['id'].endswith('nminc.co') %}
minion_add:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% elif 'act' in data and data['act'] == 'pend' and data['id'].endswith('openmbee.com') %}
minion_add:
  wheel.key.accept:
    - match: {{ data['id'] }}
{% endif %}
