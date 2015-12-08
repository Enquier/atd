test_log_context:
  local.file.append:
    - tgt: {{ data['id'] }}
    - arg:
      - /var/log/salt/context
	  - "{{ show_full_context }}"