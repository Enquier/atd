{# 
Installs pip and dependencies for custom modules
#}

install_prereqs:
  pkg.installed:
    - names:
      - python-pip
      - at
    
install_pexpect:
  pip.installed:
    - name: pexpect == 3.2
    - require:
      - pkg: python-pip