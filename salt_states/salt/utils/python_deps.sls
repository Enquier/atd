{# 
Installs pip and dependencies for custom modules
#}

python-pip:
  pkg.installed

install_pexpect:
  pip.installed:
    - name: pexpect == 3.2
    - require:
      - pkg: python-pip