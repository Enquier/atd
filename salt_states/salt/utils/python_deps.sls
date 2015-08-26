{# 
Installs pip and dependencies for custom modules
#}

python-pip:
  pkg.installed

pexpect:
  pip.installed:
    - require:
      - pkg: python-pip