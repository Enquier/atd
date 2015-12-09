test_log_context:
  local.test.echo:
    - tgt: salt.nminc.co.
    - arg:
      - {{ data.name }}