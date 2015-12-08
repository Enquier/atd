test_log_context:
  local.state.apply:
    - tgt: {{ data['id'] }}
    - arg:
      - utils.context