# Notes on usage and deployment details.

## Alfresco Installation Details

### All-In-One Installation

#### Directory structure
+ _/opt/local/alfresco_
  + _alf_data_ (data directory includes files and DB)
    + _postgresql_
  + _tomcat_
    + _shared/classes/alfresco-global.properties_

#### Services
+ `/etc/init.d/alfresco [start|stop|restart]`

### Separate Installations of Tomcat, Alfresco, Postgresql

#### Directory structure
+ _/opt/local/apache-tomcat_
  + _shared/classes/alfresco-global.properties_ (specifies dir.root where ALF files are)
+ _/mnt/alf_data_
+ _/var/lib/pgsql/9.3/data_ 

##### Services
+ `/etc/init.d/tomcat [start|stop|restart]`
+ `/etc/init.d/postgresql-9.3 [start|stop|restart]`

### Migrating data between installations

Copy the _alf_data_ and _postgresql_ data directories from the source to the target.
Don't forget to start and stop the appropriate services.

Example commands to do this:

```
%> /etc/init.d/tomcat stop

%> /etc/init.d/postgresql-9.3 stop

%> cd /var/lib/pgsql/9.3/

%> cp -prf ~cinyoung/alfresco_apache_default_db/data/ .

%> cd /mnt/alf_data/

%> cp -prf ~cinyoung/alfresco_apache_default_db/alf_data/* .

%> /etc/init.d/postgresql-9.3 start

%> /etc/init.d/tomcat start
```

#### Clean alfresco

Files are in _/home/cinyoung/alfresco_apache_default_db_ for apache installation.

Otherwise in _/home/cinyoung/alfresco_default_db_ for all in one installation.

## Scripts

### redeployLatest.sh

`./redeployLatest [snapshot|release] [version]`

Downloads the latest snapshot or release version as specified and redeploys with branding
and extensions. This wraps the call to _redeploy.sh_ with the appropriate arguments with the
latest references. Here is the flow for deployment. Scripts can be called individually as necessary,
redeployLatest wraps all the other calls for turnkey deployment.

1. `redeployLatest [snapshot|release] [version]`
  1. `getLatestArtifacts [snapshot|release] [version]`
    + Retrieves the latest artifacts for mms-repo, mms-share, and evm from artifactory
    + if release is specifed, version isn't necessary
  1. `redeploy.sh [repoAmpFile] [repoWarFile] [shareAmpFile] [shareWarFile] [mmsappDir] [mmsappZip]`
    1. Stops tomcat
    1. `installWar.sh [mmtJar] [ampFile] [warFile] [existingWarFile] [webappDir]`
      + checks the currently installed amp version (so it doesn't necessarily need to reinstall: TODOL this may need fixing)
      + backs up the existing war file
      + uninstalls any of our amps from the war file (to make sure we start clean)
      + installs our amps to the war file
      + changes ownership of war file so it's readable by tomcat
      + removes the old webapp directory
      + creates the webapp directory and explodes war into directory (so other changes not in amp can be made)
      + updates ownership of the webapp directory
      + sets the salt grain information so SALT master doesn't accidentally deploy anything over the current installation (e.g., it has to be forced rather than automatic) TODO: this may need fixing
    1. `deployMmsapp.sh [mmsappDeployDir] [mmsappZip] [backupDir]`
      + Deploys EVM by unzipping the evm zip into alfresco webapp and renaming to mmsapp then updating the ownership permissions
      + backups any existing mmsapp directory if necessary
    1. `deployRepo.sh [webappDir]`
      + Primarily makes updates to branding in the exploded web apps directory (TODO: some of the branding replacements don't work, need to add in Alfresco repo barnding updates as well)
    1. Starts tomcat

Manual Installation
===================

```
%%% on your dev machine in your alfresco-view-repo checkout - to create the target/mms-repo-ent.amp
%> mvn package -Dmaven.test.skip=true -P mbee-dev -f pom.enterprise.xml

%%% on the machine you want to deploy to
%> sudo su
%> /etc/init.d/tomcat stop
%> cd /opt/local/apache-tomcat/webapps
%> java -jar ../bin/alfresco-mmt.jar uninstall mms-repo-ent alfresco.war
%> java -jar ../bin/alfresco-mmt.jar install $YOUR_PATH/mms-repo-ent.amp alfresco.war -force
%> rm -rf alfresco
%> mkdir alfresco
%> cd alfresco
%> jar xf ../alfresco.war
%> unzip ../../amps/evm-0.2.1-SNAPSHOT.zip
%> mv build mmsapp
%> cd ..
%> chown -R tomcat:jpl alfresco alfresco.war
%> /etc/init.d/tomcat start
```
