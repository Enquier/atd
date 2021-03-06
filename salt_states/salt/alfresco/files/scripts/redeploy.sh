{% set alf_ver = grains['ALFRESCO_VERSION'] %}

#!/bin/bash
function setPaths() {
    if [ -a {{ pillar['tomcat_home'] }} ]; then
        ampPath="{{ pillar['tomcat_home'] }}/amps"
        webappPath="{{ pillar['tomcat_home'] }}/webapps"
    else
        if [ -a /opt/local/alfresco-$alf_ver ]; then
            ampPath="/opt/local/alfresco-$alf_ver/amps"
            webappPath="/opt/local/alfresco-$alf_ver/tomcat/webapps"
        else
            cwd=`pwd`
            ampPath="$cwd/amps"
            webappPath="$cwd/tomcat/webapps"
        fi
    fi
}

usage() {
  echo
  echo "usage: sudo $(basename $0) repoAmpFile|shareAmpFile [shareAmpFile|repoAmpFile] [repoWarFile] [shareWarFile] [mmsappDir] [mmsappZip]"
  echo
  echo "The order of arguments is not important. The $(basename $0) script may be called from anywhere, but the scripts on which it depends (installWar.sh, startAlfresco.sh, stopAlfresco.h, and deployMmsapp.sh) must be in the same directory as $(basename $0)."
  echo
  echo
}

# Change test_mms to 1 to just see commands without running them.
# Change test_mms to 0 to run normally.
# An existing test_mms environment variable overrides setting the value here.
if [ -z "$test_mms" ]; then
  #export test_mms=1 # just test
  export test_mms=0 # normal
fi

echo
if [[ "$test_mms" -eq "0" ]]; then
  echo "running $0 normally"
else
  echo "running $0 in test mode; will not affect server"
fi
echo

#This below doesn't work.
# BUT it probably would if using !-2 instead of !!
#checkLastCommand() {
#  if [ "$?" -ne "0" ]; then
#    echo "$0: ERROR! command failed! \"!!\""
#    exit 1
#  fi
#}


# variable initialization
d=$(dirname "$0")
installWarCommand=$d/installWar.sh
startAlfrescoCmd=$d/startAlfresco.sh
stopAlfrescoCmd=$d/stopAlfresco.sh
deployMmsappCmd=$d/deployMmsapp.sh
deployRepoCmd=$d/deployRepo.sh
installDocbookgen=$d/installDocbookgen.sh

tomcatDir={{ pillar['tomcat_home'] }}
if [ ! -d $tomcatDir ]; then
  tomcatDir=/opt/local/alfresco-{{ alf_ver }}/tomcat
  if [ ! -d $tomcatDir ]; then
    tomcatDir=/Applications/alfresco-{{ alf_ver }}/tomcat
  fi
fi
webappDir=${tomcatDir}/webapps
alfrescoWebappDir=${webappDir}/alfresco
shareWebappDir=${webappDir}/share
existingWarFile=${alfrescoWebappDir}.war
existingShareWarFile=${webappDir}/share.war
mmtJar=${tomcatDir}/bin/alfresco-mmt.jar
if [ ! -f $mmtJar ]; then
  mmtJar=${tomcatDir}/../bin/alfresco-mmt.jar
fi

mmsappDeployDir=${alfrescoWebappDir}/mmsapp
tmpDir=/tmp/mmsappZip

echo
echo initialized directories and files:
echo "  tomcatDir =" $tomcatDir
echo "  webappDir =" $webappDir
echo "  alfrescoWebappDir =" $alfrescoWebappDir
echo "  existingWarFile =" $existingWarFile
echo "  existingShareWarFile =" $existingShareWarFile
echo "  mmtJar =" $mmtJar

# process arguments
if [ "$#" -eq 0 ]; then
  echo "$0 : Error! Need at least one argument!"
  usage
  exit 1
fi;

ampFile=""
shareAmpFile=""
warFile=$existingWarFile
shareWarFile=$existingShareWarFile
mmsappDir=""
mmsappZip=""

# Look at substrings in the input to determine which input file is which
for var in "$@"
do
  if [[ $var == *zip ]]; then
    mmsappZip=$var
  else
    if [[ $var == *share* ]]; then
      if [[ $var == *amp ]]; then
        shareAmpFile=$var
      else
        if [[ $var == *war* ]]; then
          shareWarFile=$var
        else
          if [[ -d "$var" ]]; then
            mmsappDir=$var
          else
            echo "Unknown argument! " $var 
          fi
        fi
      fi
    else
#      if [[ ( $var == *repo* ) || ( $var == alfresco* ) ]]; then
        if [[ $var == *amp ]]; then
          ampFile=$var
        else
          if [[ $var == *war* ]]; then
            warFile=$var
#          fi
#        fi
          else
            if [[ -d "$var" ]]; then
              mmsappDir=$var
            else
              echo "Unknown argument! " $var 
            fi
          fi
        fi
    fi
  fi
done

echo
echo "### arguments for $0 processed with the following assignments:"
echo "  ampFile =" $ampFile
echo "  shareAmpFile =" $shareAmpFile
echo "  warFile =" $warFile
echo "  shareWarFile =" $shareWarFile
echo "  mmsappDir =" $mmsappDir
echo "  mmsappZip =" $mmsappZip

# stop alfresco server
if [[ -n "$ampFile" || -n "$shareAmpFile" ]]; then
  echo
  echo "### stop alfresco server"
  echo $stopAlfrescoCmd
  #if [[ "$test_mms" -eq "0" ]]; then
    $stopAlfrescoCmd
    if [ "$?" -ne "0" ]; then
      echo "$0: ERROR! command failed! \"!!\""
      exit 1
    fi
  #fi
else
  echo "Not stopping alfresco server since no amps are being installed."
fi

setPaths

# install mms-repo war files
if [[ -n "$ampFile" ]]; then
  echo
  echo "### install mms-repo and javascript console amp and war files"
  echo $installWarCommand $mmtJar $ampPath/javascript-console-repo-1.0.amp $warFile $existingWarFile $alfrescoWebappDir
      $installWarCommand $mmtJar $ampPath/javascript-console-repo-1.0.amp $warFile $existingWarFile $alfrescoWebappDir
  if [[ ( -f "$mmtJar" ) &&  ( -f "$ampFile" ) &&  ( -f "$warFile" ) &&  ( -f "$existingWarFile" ) &&  ( -d $(dirname $alfrescoWebappDir) ) ]]; then
    echo
    echo $installWarCommand $mmtJar $ampFile $existingWarFile $existingWarFile $alfrescoWebappDir
      $installWarCommand $mmtJar $ampFile $existingWarFile $existingWarFile $alfrescoWebappDir
    if [ "$?" -ne "0" ]; then
      echo "$0: ERROR! command failed! \"!!\""
      exit 1
    fi
  else
    echo "ERROR! Not all inputs to $installWarCommand exist for mms-repo!"
    exit 1
  fi
else
  echo
  echo "### skipping installation of mms-repo amp/war files"
fi

if [[ -n "$shareAmpFile" ]]; then
  echo
  echo "### install mms-share and javascript console amp and war files"
  echo $installWarCommand $mmtJar $ampPath/javascript-console-share-1.0.amp $shareWarFile $existingShareWarFile $shareWebappDir
      $installWarCommand $mmtJar $ampPath/javascript-console-share-1.0.amp $shareWarFile $existingShareWarFile $shareWebappDir
  if [[ ( -f "$mmtJar" ) &&  ( -f "$shareAmpFile" ) &&  ( -f "$shareWarFile" ) &&  ( -f "$existingShareWarFile" ) &&  ( -d $(dirname $shareWebappDir) ) ]]; then
    echo
    echo $installWarCommand $mmtJar $shareAmpFile $existingShareWarFile $existingShareWarFile $shareWebappDir
      $installWarCommand $mmtJar $shareAmpFile $existingShareWarFile $existingShareWarFile $shareWebappDir
    if [ "$?" -ne "0" ]; then
      echo "$0: ERROR! command failed! \"!!\""
      exit 1
    fi
  else
    echo "ERROR! Not all inputs to $installWarCommand exist for share!"
    exit 1
  fi
fi

echo "Sleeping to allow the wars to be exploded..."
sleep 10

# deploy mmsapp
echo
if [[ ( -f "$mmsappZip" ) || ( -d "$mmsappDir" ) ]]; then
  if [[ -d $(dirname $mmsappDeployDir) ]]; then
    if [[ -f "$mmsappZip" ]]; then
      echo $deployMmsappCmd $mmsappDeployDir "$mmsappZip" "$backupDir" 
      $deployMmsappCmd $mmsappDeployDir $mmsappZip $backupDir 
    else
      echo $deployMmsappCmd $mmsappDeployDir "$mmsappDir" "$backupDir" 
      $deployMmsappCmd $mmsappDeployDir $mmsappDir $backupDir 
    fi
    if [ "$?" -ne "0" ]; then
      echo "$0: ERROR! command failed! \"!!\""
      exit 1
    fi
  else
    echo "ERROR! Directory $(dirname $mmsappDeployDir) does not exist! Cannot run $deployMmsappCmd."
    exit 1
  fi
else
  echo
  echo "### skipping installation of mms-share amp/war files"
fi


echo
echo $deployRepoCmd $alfrescoWebappDir
$deployRepoCmd $alfrescoWebappDir
echo $deployRepoCmd $shareWebappDir
$deployRepoCmd $shareWebappDir
echo $installDocbookgen
$installDocbookgen


# bkp catalina.out, otherwise waitOnServer.py will see old startup
mv {{ pillar['tomcat_home'] }}/logs/catalina.out {{ pillar['tomcat_home'] }}/logs/catalina.out.$(date +%s)

#start server
if [[ -n "$ampFile" || -n "$shareAmpFile" ]]; then
  echo
  echo "### start alfresco server"
  echo $startAlfrescoCmd
  $startAlfrescoCmd
else
  echo "Not restarting alfresco server since no amps were being installed."
fi

# need to get directory of file being run
d=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $d
date
# wait for server to start then initialize the caches
# TODO: investigate why this causes tomcat to stop...
#echo "python waitOnServer.py -f {{ pillar['tomcat_home'] }}/catalina.out"
#python $d/waitOnServer.py -f {{ pillar['tomcat_home'] }}/logs/catalina.out
#
#date
#echo "python initialize_caches.py -user mmsAdmin:letmein"
#python $d/initialize_caches.py -user mmsAdmin:letmein

echo
echo "Success!"

exit 0

