{% set alf_ver = grains['ALFRESCO_VERSION'] %}

#!/bin/bash
# do a clean install

# This script deploys all the add ons and branding to the exploded war directories

myUsage() {
  echo
  echo "usage: sudo $(basename $0)"
  echo
}

function main() {
  if [ "$#" -gt 1 ]; then
    echo "$0 : ERROR! No arguments needed"
    myUsage
    exit 1
  fi

  # Change test_mms to 1 to just see commands without running them.
  # Change test_mms to 0 to run normally.
  # An existing test_mms environment variable overrides setting the value here.
  if [ -z "$test_mms" ]; then
    export test_mms=1 # just test
    #export test_mms=0 # normal
  fi

  if [ -a {{ pillar['tomcat_home'] }} ]; then
    export path="{{ pillar['tomcat_home'] }}/amps"
    export owner="tomcat:jpl"
  elif [ -a /opt/local/alfresco-{{ alf_ver }} ]; then
    export path="/opt/local/alfresco-{{ alf_ver }}/amps"
    export owner="alfresco:jpl"
  elif [ -a /Applications/alfresco-{{ alf_ver }} ]; then
    export path="/Applications/alfresco-{{ alf_ver }}/amps"
  else
    export path="."
  fi

  # add in all the Repository/Share updates
  if [[ $explodedWarDir = *alfresco ]]; then
    installJar $path/javascript-console-repo-0.5.1.jar
    updateOsbReference
  elif [[ $explodedWarDir = *share ]]; then
    installJar $path/javascript-console-share-0.5.1.jar
    installJar $path/media-viewers-2.5.1.jar
    updateShare
  fi
}


# updates Share branding and Dashlets as appropriate
function installAllInOne() {
  /etc/init.d/alfresco stop

  `cd /opt/local/alfresco/`
  `rm -rf alf_data`
  `cp -rpf ~cinyoung/alfresco_default_db/alf_data .`

  /etc/init.d/alfresco start
}

# update the OSB reference depending on the hostname
function installSeparate() {
  `/etc/init.d/tomcat stop`
  `/etc/init.d/postgresql-9.3 stop`

  `cd /var/lib/pgsql/9.3`
  `rm -rf data`
  `cp -prf ~cinyoung/alfresco_apache_default_db/data .`
  `cd /mnt/alf_data`
  `rm -rf backup-lucene-indexes contentstore contenstore.deleted keystore lost+found lucene-indexes oouser`
  `cp -prf ~cinyoung/alfresco_apache_default_db/alf_data/* .`

  `/etc/init.d/tomcat start`
  `/etc/init.d/postgresql-9.3 start`
}


main 

exit 0
