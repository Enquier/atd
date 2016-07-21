
#!/bin/bash

# This script grabs all the latest artifacts from Artifactory as necessary

if [ -a {{ pillar['tomcat_home'] }} ]; then
    export path="{{ pillar['tomcat_home'] }}/amps"
    export owner="tomcat:tomcat"
else
    if [ -a /opt/local/alfresco-4.2.e ]; then
        export path="/opt/local/alfresco-4.2.e/amps"
        export owner="alfresco:alfresco"
    else
        export path="."
    fi
fi

if [ ! -a $path ]; then
  echo "creating amps directory"
  mkdir $path
fi

ARTIFACTORY_URL='https://build.nminc.co/artifactory'

# @param releaseOrSnapshot  Specify release or snapshot to download
# @param mmsVersion   Specify mms version (e.g., 2.0)
function main() {
  releaseOrSnapshot=$1

  mainMmsVersion=$2

  # always grab the alfresco extensions
   getLatestArtifact "libs-release-local" "org/sharextras" "javascript-console-repo" "amp" "1.0"
   getLatestArtifact "libs-release-local" "org/sharextras" "javascript-console-share" "amp" "1.0"
   getLatestArtifact "ext-release-local" "gov/nasa/jpl/alfresco/share" "media-viewers" "jar"
  
  # docbookgen is needed for configuration
  getLatestArtifact "libs-release-local" "gov/nasa/jpl/mbee/docbookgen" "docbookgen" "tar.gz"

  if [[ $releaseOrSnapshot == release ]]; then
    repoRepository="libs-release-local"
  else
    repoRepository="libs-snapshot-local"
    mainMmsVersion="$mainMmsVersion-SNAPSHOT"
  fi
  
  # find the artifact name (based on enterprise)
  repoName="mms-repo"
  shareName="mms-share"
  alfrescoRepoJarVersion="4.2.f"
  if hash salt-call 2>/dev/null; then
    alf_license=`salt-call -g | awk '/ALFRESCO_LICENSE_TYPE/{getline; print}' | awk '{$1=$1}1'`
  else
    alf_license=""
  fi

  if [[ $alf_license == enterprise ]]; then
    repoName=$repoName"-ent"
    shareName=$shareName"-ent"
    alfrescoRepoJarVersion="4.2.3.3"
  fi

  getLatestArtifact $repoRepository "gov/nasa/jpl" $repoName "amp" $mainMmsVersion
  getLatestArtifact $repoRepository "gov/nasa/jpl" $shareName "amp" $mainMmsVersion
  getLatestArtifact $repoRepository "gov/nasa/jpl" "evm" "zip" $mainMmsVersion

  # Need to get our patched alfresco-repository job that fixes heisenbug
  downloadArtifact "libs-release-local" "org/alfresco" "alfresco-repository" "jar" $alfrescoRepoJarVersion

}


# get the latest release artifact
# @param repository   For example libs-release-local
# @param package      For example gov/nasa/jpl
# @param artifactId   For example javascript-console-repo
# @param artifactType Really the artifact extension, e.g., amp, jar
# @param mmsVersion   Specify mms version (e.g., 2.0)
function getLatestArtifact () {
  repository=$1
  package=$2
  artifactId=$3
  artifactType=$4
  mmsVersion=$5

  echo getLatestArtifact $repository $package $artifactId $artifactType $mmsVersion

  getVersions $repository $package $artifactId $mmsVersion
  downloadArtifact $repository $package $artifactId $artifactType $latestVersion
  echo "done getting latest release artifact for $artifactId"
  echo
}


# get the versions from artifactory
# latest - is latest version number
# release - is last deployed version number (e.g., from workspace will be less than develop)
# @param repository   For example libs-release-local
# @param package      For example gov/nasa/jpl
# @param artifactId   For example javascript-console-repo
# @param mmsVersion   Specify mms version (e.g., 2.0)
function getVersions() {
  repository=$1
  package=$2
  artifactId=$3
  mmsVersion=$4

  echo "determining latest version of $artifactId..."
  if [ $mmsVersion ]; then
    latestVersion=$mmsVersion
  else
    latestVersion=`curl -s $ARTIFACTORY_URL/$repository/$package/$artifactId/maven-metadata.xml | grep latest | sed 's/<latest>//g' | sed 's/<\/latest>//g' | sed 's/ //g'`
  fi
  echo "    latestVersion: $latestVersion"
}

# downloads only if artifact doesn't already exist
# @param repository   For example libs-release-local
# @param package      For example gov/nasa/jpl
# @param artifactId   For example javascript-console-repo
# @param artifactType Really the artifact extension, e.g., amp, jar
# @param version      Version of artifact to download
function downloadArtifact() {
  repository=$1
  package=$2
  artifactId=$3
  artifactType=$4
  version=$5

  filename=$artifactId-$version.$artifactType
  echo "Attempting to download $filename"
  #if [ -a $path/$filename ]; then
  #  echo "  $path/$filename already exists"
  #else
    echo "  downloading $filename to $path"
    
    # if snapshot, need to get filename with timestamp
    if [[ $version == *SNAPSHOT* ]]; then
      getSnapshotFilename $repository $package $artifactId $artifactType $version
    else
      srcFilename=$filename
    fi

    # download the actual file
    echo "curl -s $ARTIFACTORY_URL/$repository/$package/$artifactId/$version/$srcFilename > $path/$filename"
    curl -s $ARTIFACTORY_URL/$repository/$package/$artifactId/$version/$srcFilename > $path/$filename
    if [ $owner ]; then
      chown $owner $path/$filename
    fi
    echo "  completed download"
  #fi
}


# Gets the snapshot filename since it changes based on timestamp
# @param repository   For example libs-release-local
# @param package      For example gov/nasa/jpl
# @param artifactId   For example javascript-console-repo
# @param artifactType Really the artifact extension, e.g., amp, jar
# @param version      Version of artifact to download
function getSnapshotFilename() {
  repository=$1
  package=$2
  artifactId=$3
  artifactType=$4
  version=$5

  echo "  getting snapshot filename..."
  srcFilename=`curl -sL $ARTIFACTORY_URL/$repository/$package/$artifactId/$version | grep "href" | grep "$artifactId" | cut -d '"' -f2 | grep "$artifactType" | grep -v ".md5" | grep -v ".sha1" | sort -r | head -1`
  echo "    $srcFilename"
}


# downloads only if artifact doesn't already exist
# @param repository   For example libs-release-local
# @param package      For example gov/nasa/jpl
# @param artifactId   For example javascript-console-repo
# @param artifactType Really the artifact extension, e.g., amp, jar
function getNonMavenLatestArtifacts() {
  repository=$1
  package=$2
  artifactId=$3
  artifactType=$4
  version=$5

  versionSearch=`echo "$version" | sed 's/\./[.]/' | sed 's/-SNAPSHOT//'`

  echo $versionSearch

  # get non-europa first
  latestVersion=`curl -sL $ARTIFACTORY_URL/$repository/$package/$artifactId/ | grep "$versionSearch" | grep '<a href' | cut -d '>' -f2 | grep -v href | grep -v europa | cut -d '/' -f1 | sort | tail -1`
  #echo "curl -sL $ARTIFACTORY_URL/$repository/$package/$artifactId/ | grep "$versionSearch" | grep '<a href' | cut -d '>' -f2 | grep -v href | grep -v europa | cut -d '/' -f1 | sort | tail -1"
  downloadArtifact $repository $package $artifactId $artifactType $latestVersion

  # get europa next
  #latestVersion=`curl -sL $ARTIFACTORY_URL/$repository/$package/$artifactId/ | grep "$versionSearch" | grep '<a href' | cut -d '>' -f2 | grep -v href | grep europa | cut -d '/' -f1 | sort | tail -1`
  #downloadArtifact $repository $package $artifactId $artifactType $latestVersion
}


function myUsage() {
  echo
  echo "usage: sudo $(basename $0) release|snapshot [version]"
  echo "       if version not specified, gets latest mms-repo/share based on release or snapshot"
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
main $1 $2 $3
