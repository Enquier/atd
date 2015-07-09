{# When an server connects, run state.highstate. #}
highstate_run:
  cmd.state.highstate:
    - tgt: {{ data['id'] }}
