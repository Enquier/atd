{% set alf_ver = grains['ALFRESCO_VERSION'] %}

#!/bin/bash
# deploy repo

# This script deploys all the add ons and branding to the exploded war directories

myUsage() {
  echo
  echo "usage: sudo $(basename $0) explodedWarDir [enterprise]"
  echo
}

function main() {
  if [ "$#" -lt 1 ]; then
    echo "$0 : ERROR! Need at least one argument!"
    myUsage
    exit 1
  fi
  if [ "$#" -gt 2 ]; then
    echo "$0 : ERROR! No more than two arguments!"
    myUsage
    exit 1
  fi

  echo "deployRepo.sh $1"

  # Change test_mms to 1 to just see commands without running them.
  # Change test_mms to 0 to run normally.
  # An existing test_mms environment variable overrides setting the value here.
  if [ -z "$test_mms" ]; then
    export test_mms=1 # just test
    #export test_mms=0 # normal
  fi

  explodedWarDir=$1
  cd $explodedWarDir

  if [ -a {{ pillar['tomcat_home'] }} ]; then
    export path="{{ pillar['tomcat_home'] }}/amps"
    export owner="tomcat:tomcat"
  elif [ -a /opt/local/alfresco-{{ alf_ver }} ]; then
    export path="/opt/local/alfresco-{{ alf_ver }}/amps"
    export owner="alfresco:alfresco"
  elif [ -a /Applications/alfresco-{{ alf_ver }} ]; then
    export path="/Applications/alfresco-{{ alf_ver }}/amps"
  else
    export path="."
  fi

  # add in all the Repository/Share updates
  if [[ $explodedWarDir = *alfresco ]]; then
    installJar $path/javascript-console-repo-0.5.1.jar

    # grab the correct patched repository jar
    if hash salt-call 2>/dev/null; then
      alf_license=`salt-call -g | awk '/ALFRESCO_LICENSE_TYPE/{getline; print}' | awk '{$1=$1}1'`
    else
      alf_license=""
    fi
    if [[ $alf_license == enterprise ]]; then
      installJar $path/alfresco-repository-4.2.3.3.jar
    else
      installJar $path/alfresco-repository-4.2.e.jar
    fi
    hname=`hostname`
    updateRepo $hname
  elif [[ $explodedWarDir = *share ]]; then
    installJar $path/javascript-console-share-0.5.1.jar
    installJar $path/media-viewers-2.5.1.jar
    updateShare
  fi
  
  cd -
}


# updates Share branding and Dashlets as appropriate
function updateShare() {
  # update the dashlets to point to the deployed host
  hname=`hostname`
  #if [[ ! $hname == *jpl.nasa.gov ]]; then
  #  hname=$hname.jpl.nasa.gov
  #fi

  # remove europa branding if necessary
  if [[ ! "$hname" == *europa* ]]; then
    echo
    echo "find . -name 'login.get.html.ftl' -exec sed -i 's/var style/\/\/var style/' {} \;"
    find . -name 'login.get.html.ftl' -exec sed -i 's/var style/\/\/var style/' {} \;
    echo
    echo "find . -name 'login.get.html.ftl' -exec sed -i 's/elems\[/\/\/elems\[/' {} \;"
    find . -name 'login.get.html.ftl' -exec sed -i 's/elems\[/\/\/elems\[/' {} \;
  fi

  updateShareName $hname

  # TODO: Overwrite the icon
}

# update the Repo branding as appropriate
function updateRepo() {
  updateOsbReference $1

  echo
  echo "find . -name 'footer.get.html.ftl' -exec sed -i 's/<img .*$//' {} \;"
  find . -name 'footer.get.html.ftl' -exec sed -i 's/<img .*$//' {} \;

  
  hname=`echo "$1" | cut -d'.' -f1` 
  if [[ "$hname" == europaems ]]; then
    # do nothing
    echo "doing nothing since we're on europaems"
  else
   echo
   echo "find . -name '*_user_email.ftl' -exec sed -i 's/Europa/'$hname'/g' {} \;" 
   find . -name '*_user_email.ftl' -exec sed -i 's/Europa/'$hname'/g' {} \; 
   echo "find . -name 'notify.html' -exec sed -i 's/Europa/'$hname'/g' {} \;" 
   find . -name 'notify.htm' -exec sed -i 's/Europa/'$hname'/g' {} \; 
  fi
}


# update the OSB reference depending on the hostname
# @param hname	Hostname
function updateOsbReference() {
  hname=`echo "$1" | cut -d'.' -f1`
  if [[ "$hname" == europaems-int ]]; then
    osbName="europadea-int"
    osbPort=""
  elif [[ "$hname" == *test ]]; then
    # do nothing - by default points to test server
    osbName="orasoa-dev07"
    osbPort="8121"
  elif [[ "$hname" == europaems ]]; then
    osbName="europadea"
    osbPort=""
  elif [[ "$hname" == ems ]]; then
    osbName="orasoa-dev07"
    osbPort="8121"
  else
    osbName="orasoa-dev07"
    osbPort="8121"
  fi
  replaceServiceContextXml $osbName $osbPort
}


function replaceServiceContextXml() {
  osbName=$1
  osbPort=$2

  echo "find . -name 'service-context.xml' -exec sed -i 's/orasoa-dev07/'$osbName'/' {} \;"
  find . -name "service-context.xml" -exec sed -i 's/orasoa-dev07/'$osbName'/' {} \;
  if [[  "$osbPort" = "" ]]; then
    echo "find . -name 'service-context.xml' -exec sed -i 's/:8121//' {} \;"
    find . -name "service-context.xml" -exec sed -i 's/:8121//' {} \;
  else
    echo "find . -name 'service-context.xml' -exec sed -i 's/:8121/:'$osbPort'/' {} \;"
    find . -name "service-context.xml" -exec sed -i 's/:8121/:'$osbPort'/' {} \;
  fi
}

# update the share name to the specified name
# @param  name  Fully qualified hostname
function updateShareName() {
  name=$1
  name=`echo "$name" | cut -d'.' -f1`
  if [[ "$name" == europaems* ]]; then
    shareName="Europa Engineering Modeling System"
    iconName='europa'
  elif [[ "$name" == ems* ]]; then
    shareName="Community"
    iconName='jpl'
    #removeShareHeader
  elif [[ "$name" == msm* ]]; then
    shareName="Mars 2020"
    iconName='msm'
    #removeShareHeader
  elif [[ "$name" == www.openmbee.com ]]; then
    shareName="OpenMBEE Community Server"
    iconName='openmbee'
    #removeShareHeader
  else
    shareName=`echo "$name" | cut -d'-' -f1`
    #removeShareHeader
  fi

  replaceShareName $name $shareName
  replaceShareIcon $iconName
}


# remove the share header if not on a europa machine
#function removeShareHeader() {
#  echo
#  echo "find . -name 'share-header.lib.js' -exec rm -f {} \;"
#  if [ $test_mms = 0 ]; then
#    find . -name 'share-header.lib.js' -exec rm -f {} \;
#  fi
#}


# replace the Share name on the login page
# @param  name      Local hostname (e.g., ems-test)
# @param  shareName Login page name
function replaceShareName() {
  name=$1
  shareName=$2
  subName=`echo "$name" | cut -d'-' -f2`

  if [ $subName ]; then
    shareName="$shareName-$subName"
  fi
  echo
  echo "find . -name 'login.get.html.ftl' -exec sed -i 's/Europa Engineering Modeling System/'$shareName'/g' {} \;"
  find . -name 'login.get.html.ftl' -exec sed -i 's/Europa Engineering Modeling System/'$shareName'/g' {} \;
}


# replace the share icon reference
# @param icon name
function replaceShareIcon() {
  name=$1
  if [ $name ]; then
    echo
    echo "find . -name 'login.get.html.ftl' -exec sed -i 's/'europa-icon.png'/'$name-icon.png'/' {} \;"
    find . -name 'login.get.html.ftl' -exec sed -i 's/'europa-icon.png'/'$name-icon.png'/' {} \; 
  else
    # remove the icon
    echo
    echo "find . -name 'login.get.html.ftl' -exec sed -i 's/<img .*$//' {} \;"
    find . -name 'login.get.html.ftl' -exec sed -i 's/<img .*$//' {} \;
  fi
}


# updates the ownership recursively on the provided input
# @param file   File to update ownerships on
function updateOwner() {
  file=$1
  if [ $owner ]; then
    echo "chown -R $owner $file"
    if [ $test_mms = 0 ]; then
      chown -R $owner $file
    fi
  fi
}


# install the JAR into the WEB-INF lib directory
# @param inputFile  JAR file to copy into the WEB-INF lib directory
function installJar() {
  inputFile=$1
  echo "cp $inputFile $explodedWarDir/WEB-INF/lib"
  if [ $test_mms = 0 ]; then
    cp $inputFile $explodedWarDir/WEB-INF/lib
    filename=`echo $inputFile | rev | cut -d'/' -f1 | rev`
    updateOwner $explodedWarDir/WEB-INF/lib/$filename
  fi
}


main $1 $2

exit 0
