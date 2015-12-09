test_log_context:
  local.test.echo:
    - tgt: {{ data['id'] }}
    - arg:
      - {{ show_full_context() }}