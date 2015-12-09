test_log_context:
  local.test.echo:
    - tgt: test2.nminc.co
    - arg:
      - {{ show_full_context() }}