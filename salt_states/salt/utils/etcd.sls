include:
  - utils

etcd_deps:
  pkg.installed:
    - order: 1
    - names:
      - go
