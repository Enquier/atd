#!/bin/bash

usage="usage: sudo $0 mmtJar ampFile warFile existingWarFile explodedWebappDir"

# Change test_mms to 1 to just see commands without running them.
# Change test_mms to 0 to run normally.
# An existing test_mms environment variable overrides setting the value here.
if [ -z "$test_mms" ]; then
  export test_mms=1 # just test
  #export test_mms=0 # normal
fi

if [[ ( ! "$#" -eq 4 ) &&  ( ! "$#" -eq 5 ) ]]; then
#if [ ! "$#" -eq 3 ]; then
  echo "$0 : Error! Need at least three arguments! number of passed args = $#"
  echo $usage
  exit 1
fi

mmtJar=$1
ampFile=$2
warFile=$3
existingWarFile=$4
explodedWebappDir=$5

explodeParentDir=$(dirname $explodedWebappDir)

# Use the owner of the webapp directory as the owner of the deployed webapp
owner=`ls -ld $explodeParentDir | cut -d' ' -f 3`

echo
echo "arguments for $0 processed with the following assignments and inferred values:"
echo "  mmtJar =" $mmtJar
echo "  ampFile =" $ampFile
echo "  warFile =" $warFile
echo "  existingWarFile =" $existingWarFile
echo "  explodedWebappDir =" $explodedWebappDir
echo "  explodeParentDir =" $explodedWebappDir
echo "  owner =" $owner

# check version of AMP vs last deployed version
jar xvf $ampFile module.properties
ampVersion=`grep "module.version" module.properties | cut -d'=' -f2`
ampID=`grep "module.id" module.properties | cut -d'=' -f2`
rm module.properties

if [ $ampVersion ]; then
  echo "AMP Version: $ampVersion"
  warVersion=`find $explodedWebappDir -name "module.properties" -exec grep -H "module.version" {} \\; | grep $ampID | cut -d'=' -f2`
  if [ $warVersion ]; then
    echo "WAR Version: $warVersion"
    if [ $ampVersion = $warVersion ]; then
      echo "AMP and WAR have same version, not installing"
      exit 0
    fi
  else
    echo "Installing version $ampVersion"
  fi
fi


# backup war file
if [ ! $existingWarFile -ef $warFile ]; then
  echo
  echo "##### backup war file"
  echo cp $existingWarFile ${existingWarFile}.`date '+%Y%m%d-%H%M%S'`
  if [[ "$test_mms" -eq "0" ]]; then
    cp $existingWarFile ${existingWarFile}.`date '+%Y%m%d-%H%M%S'`
    if [ "$?" -ne "0" ]; then
      echo "$0: ERROR! command failed! \"!!\""
      exit 1
    fi
  fi
  # use specified warFile
  echo "##### use specified warFile"
  echo cp -f $warFile $existingWarFile
  if [[ "$test_mms" -eq "0" ]]; then
    cp -f $warFile $existingWarFile
  fi
fi

# uninstall any previous amps from the war - do these blindly since it doesn't hurt
# TODO: we can remove view-repo/share in future as those aren't being used
echo
echo "##### uninstall amp from war"
if [ $warVersion ]; then
  echo java -jar $mmtJar uninstall $ampID $existingWarFile
if [[ "$test_mms" -eq "0" ]]; then
  java -jar $mmtJar uninstall $ampID $existingWarFile
fi
else
  echo "Previously Uninstalled"
fi
# install amp to war
echo
echo "##### install amp to war"
echo java -jar $mmtJar install $ampFile $existingWarFile -force
temp=`mktemp`
if [[ "$test_mms" -eq "0" ]]; then
  java -jar $mmtJar install $ampFile $existingWarFile -force | tee $temp | head -n 5
  echo . . .
  tail -n 5 $temp
  /bin/rm -rf $temp
fi

# change owner if specified
if [ -n "$owner" ]; then
  echo
  echo "##### change owner of war file"
  echo chown ${owner}:${owner} $existingWarFile
  if [[ "$test_mms" -eq "0" ]]; then
    chown ${owner}:${owner} $existingWarFile
  fi
  #chown tomcat:tomcat $existingWarFile
fi

if [[ ( -z "$explodedWebappDir" ) || ( ! -d $explodeParentDir  )]]; then
  echo
  echo "No webapp directory to explode war!  Not exploding war."
  echo
else
  if [[ $ampID = de* ]]; then
    echo "$ampID Installed"
  else
  echo
  # blast alfresco directory
  echo "##### blast alfresco directory"
  if [ -d $explodedWebappDir ]; then
    echo rm -rf $explodedWebappDir
    if [[ "$test_mms" -eq "0" ]]; then
      rm -rf $explodedWebappDir
    fi
  fi

  # explode war
  echo "##### explode war in target directory"
  echo mkdir $explodedWebappDir
  if [[ "$test_mms" -eq "0" ]]; then
    mkdir $explodedWebappDir
  fi

  echo
  echo pushd $explodedWebappDir
  pushd $explodedWebappDir

  echo
  echo jar xf $existingWarFile
  if [[ "$test_mms" -eq "0" ]]; then
    jar xf $existingWarFile
  fi

  # change owner
  echo
  echo "##### change owner of deployed web app"
  echo chown -Rh ${owner}:${owner} $explodedWebappDir
  if [[ "$test_mms" -eq "0" ]]; then
    chown -Rh ${owner}:${owner} $explodedWebappDir
  fi

  # get back to where we were
  echo
  echo "##### get back to the directory where we were"
  echo popd
  popd
  fi
fi

# set the SALT grain on minion to indicate that MMS was deployed
if [ ! -f /etc/salt/grains ]; then
  touch /etc/salt/grains
  chmod 666 /etc/salt/grains
fi
if [[ `grep MMS_RELEASE_INSTALLED /etc/salt/grains` ]]; then
  echo 'updating salt grain to indicate MMS_RELEASE_INSTALLED'
  sed -i 's/.*MMS_RELEASE_INSTALLED.*/MMS_RELEASE_INSTALLED: true/'
else
  echo 'MMS_RELEASE_INSTALLED: true' >> /etc/salt/grains
fi

exit 0
