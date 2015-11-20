context_event:
  local.state.apply:
    - tgt: 'farm_name: salt'
    - expr_form: grain
    - args:
      - utils.context