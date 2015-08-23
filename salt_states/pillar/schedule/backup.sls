schedule:
  tw-ec2-snapshot:
    function: cloud.action
    args:
      - create_snapshot
    kwargs:
      provider: nminc_aws
      volume_id: vol-0a1f91eb
      m_name: tw.nminc.co-001-backup
    when: 6:00pm
  ea-ec2-snapshot:
    function: cloud.action
    args:
      - create_snapshot
    kwargs:
      provider: nminc_aws
      volume_id: vol-369643d7
      m_name: ea.nminc.co-001-backup
    when: 6:30pm