{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
openssh-server:
  pkg: 
   - installed
   - name: openssh-server
  service:
   - name: sshd
   - running
   - enable: True
   - reload: True
   - watch:
     - file: /etc/ssh/sshd_config
     - file: /etc/ssh/sshd-banner

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://sshd/files/sshd_config.default
    - user: root
    - group: root

/etc/ssh/sshd-banner:
  file.managed:
    - source: salt://sshd/files/sshd-banner.default
    - user: root
    - group: root

