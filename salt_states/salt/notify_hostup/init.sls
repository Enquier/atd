{% set EmailAddress = grains['ALERT_EMAIL'] %}

send_notify_email:
  cmd.run:
    - order: 150
    - name: 'echo "ServerHostname: " `hostname` >> /tmp/emailNotice.txt; echo "ServerIP: " `ifconfig eth0 | grep "inet addr:" | cut -d: -f2 ` >> /tmp/emailNotice.txt; echo "ServerGrains:" >> /tmp/emailNotice.txt; cat /etc/salt/grains >> /tmp/emailNotice.txt; mail -s "SCALR NOTICE :: Your server is now online" {{ EmailAddress }} < /tmp/emailNotice.txt'
    - onlyif: test ! -e /tmp/Host_Already_Configured.txt

/tmp/Host_Already_Configured.txt:
  file.managed:
    - order: last
    - source: salt://notify_hostup/files/Host_Already_Configured.txt
    - user: root
    - group: root

