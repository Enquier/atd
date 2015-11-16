{# server faild to authenticate -- remove accepted key #}
{% if not result and ( id.endswith('nminc.co') or id.endswith('openmbee.com') ) %}
minion_remove:
  wheel.key.delete:
    - match: {{ id }} minion_rejoin:
  cmd.cmd.run:
    - tgt: salt
    - arg:
      - ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "{{ id }}" 'sleep 10 && /etc/init.d/salt-minion restart'
{% endif %}

{# server is sending new key -- accept this key #}
{% if act == 'pend' and id.endswith('nminc.co') %}
minion_add:
  wheel.key.accept:
    - match: {{ id }}
{% elif act == 'pend' and id.endswith('openmbee.com') %}
minion_add:
  wheel.key.accept:
    - match: {{ id }}
{% endif %}
