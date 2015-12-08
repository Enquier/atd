test_log_context:
  local.file.append:
    - tgt: {{ data['id'] }}
    - arg:
      - /var/log/salt/context
	  - args='{{ show_full_context }}'