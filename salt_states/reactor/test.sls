test_log_context:
  local.file.append:
    - tgt: {{ data['name'] }}
    - arg:
      - /var/log/salt/context
	  - "{{ show_full_context }}"