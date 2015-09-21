
###START ALFRESCO VERSION SET BY SALT DO NOT EDIT####

####END ALFRESCO VERSION SET BY SALT DO NOT EDIT####

# downloads latest artifacts and deploys them as necessary

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


function setFileVariables() {
    hname=$1

    if [[ $releaseOrSnapshot == release ]]; then
        grepString="-v SNAPSHOT"
    else
        grepString="SNAPSHOT"
    fi
    repoAmpFile=`ls -t $ampPath/mms-repo*.amp | grep $grepString | head -1`
    shareAmpFile=`ls -t $ampPath/mms-share*.amp | grep $grepString | head -1`

    repoWarFile=`ls -t $webappPath/alfresco*.bak | tail -1`
    echo "#### REPOWARFILE:  " $repoWarFile
    if [ ! $repoWarFile ]; then
        repoWarFile=$webappPath/alfresco.war
    fi
    shareWarFile=`ls -t $webappPath/share*.bak | tail -1`
    if [ ! shareWarFile ]; then
        shareWarFile=$webappPath/share.war
    fi
    mmsappDir=$webappPath/alfresco/mmsapp

    if [[ $hname == *europa* ]]; then
        mmsappZip=`ls -t $ampPath/evm*europa*.zip | grep $grepString | head -1`
    else
        mmsappZip=`ls -t $ampPath/evm*.zip | grep $grepString | grep -v europa | head -1`
    fi

    echo repoAmpFile:"   "$repoAmpFile
    echo repoWarFile:"   "$repoWarFile
    echo shareAmpFile:"  "$shareAmpFile
    echo shareWarFile:"  "$shareWarFile
    echo mmsappZip:"     "$mmsappZip
}


function main() {
    releaseOrSnapshot=$1
    mmsVersion=$2

    hname=`hostname | cut -d'.' -f1`

    setPaths

    d=$(dirname "$0")
    echo $d/getLatestArtifacts.sh $releaseOrSnapshot $mmsVersion
    $d/getLatestArtifacts.sh $releaseOrSnapshot $mmsVersion
    setFileVariables $hname $releaseOrSnapshot

    echo redeploy.sh $repoAmpFile $repoWarFile $shareAmpFile $shareWarFile $mmsappDir $mmsappZip $ampPath
    $d/redeploy.sh $repoAmpFile $repoWarFile $shareAmpFile $shareWarFile $mmsappDir $mmsappZip $ampPath
}


function myUsage() {
  echo
  echo "usage: sudo $(basename $0) release|snapshot [version]"
  echo "       if version not specified, gets latest mms-repo/mms-shared in release or snapshot"
  echo
}


if [ "$#" -lt 1 ]; then
  echo "$0 : ERROR! Need at least one arguments!"
  myUsage
  exit 1
fi
if [ "$#" -gt 2 ]; then
  echo "$0 : ERROR! No more than two arguments!"
  myUsage
  exit 1
fi

# call the main 
# Takes as input branch to take from
main $1 $2

exit 0
