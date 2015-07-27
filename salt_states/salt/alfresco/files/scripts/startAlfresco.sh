#!/bin/bash
#start server
echo "##### start alfresco server"

#change test_mms to 1 to just see commands without running them
#change test_mms to 0 to run normally

if [ -z "$test_mms" ]; then
  export test_mms=1 # just test
  #export test_mms=0 # normal
fi

d=$(dirname "$0")
getPidCommand=$d/getAlfrescoPid.sh

pid=`${d}/getAlfrescoPid.sh`

if [ -n "$pid" ]; then
  echo "Alfreco server is still running as pid=$pid . . . not restarting!"
  exit 1
fi

if [ -e /etc/systemd/system/multi-user.target.wants/alfresco.service ]; then
  echo systemctl start alfresco
  if [[ "$test_mms" -eq "0" ]]; then
    systemctl start alfresco
  fi
elif [ -e /etc/systemd/system/multi-user.target.wants/tomcat.service ]; then
  echo systemctl start tomcat
  if [[ "$test_mms" -eq "0" ]]; then
    systemctl start tomcat
  fi
else
  echo /etc/init.d/tomcat start
  if [[ "$test_mms" -eq "0" ]]; then
    /etc/init.d/tomcat start
  fi
fi

exit 0
