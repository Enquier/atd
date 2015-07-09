adt/salt_states/srv/salt/alfresco
==========

Installs and configures alfresco on a system. 

init.sls
===

Placeholder file. Currenlty not used. 

copy.sls
===

Copies the alfresco zip file release to the remote host. 

The file copied is determined by the salt grain "ALFRESCO_LICENSE_TYPE". This grain is set during the bootstrap process and is set using a vairable in the scalr farm that the host is in. The variable is "SCALR_ALFRESCO_LICENSE_TYPE" and has two possible settings.

Either "community" for the free version of alfresco, or "enterprise" for the version we have a license for. 

Once the zip file is copied to the remote host it is unpacked to the directory /usr/src/alfresc_deploy so that its contents can be copied to the correct locations on the filesystem. 

deploy.sls
===

Creates the /opt/apache-tomcat/endorsed and /opt/apache-tomcat/licenses directories in the tomcat server home. 

Copies the required files from the /usr/src/alfresco_deploy directory into the tomcat server. (file list below). 

1. postgresql-9.0-802.jdbc4.jar
2. serializer.jar
3. xalan.jar
4. alfresco-mmt.jar
5. apply_amps.sh

If the ALFRESCO_LICENSE_TYPE is set to "enterprise" then the license file is also installed to:

/opt/apache-tomcat/shared/classes/alfresco/extension/license/alfresco_enterprise_license.lic:


The alf_data directory is also created by pulling the following data from the environment. 

1. environment (stage, prod, test, qa, etc...)
2. farm (Name of the farm. Pulled from scalr as SCALR_FARM_NAME and set as a grain during bootstrap)
3. alf_type (License type (community or enterprise) Pulled from scalr using SCALR_ALFRESCO_LICENSE_TYPE and set as a grain during bootstrap). 

The directory is created under /mnt/ If the system is on AWS and is "europa" branded (in an europa farm) and the license type is enterprse a NFS share is mounted. It uses the following format. 

/mnt/{{ environment }}_alf_data_nfs/{{ farm }}_{{ environment }}_{{ alf_type }} 


amps_deploy.sls
===

Applies our project AMPS to the alfresco.war and share.war files. 

Uses salt grains "node_env" to locate which set of amps to install. These are stored on the salt master under the "large_files_store". They are located in a folder with the format of "alfresco/files/{{ environment }}". 

The enviornmnet is pulled from the servers grains and is gathered from the role alias for the instance. 

Ideally these files are updated from the jenkins CI system and placed in the proper directories for deployment. 

Amps_deploy also makes sure that the /opt/apache-tomcat directory is properly owned by the "tomcat" user and group. This resolves an issue with .war files not being automatically decompressed on a host if it is not owned by the tomcat user. 


decompress_war.sls
===

This state unpacks the .war files (alfresco and share) manually before the tomcat service is started. This step is required as we need to place a number of configuration files into different folders that only exist after the .war files have been decompressed. Otherwise there will be errors on the tomcat's first run. 


configure.sls
===

We install the default configurations for LDAP and alfresco in this step. 

alfresco-global.properties contains jinja templating and is able to automatically detect and set configurations for which database server to connect to. It currently will only connect to a database server that is either running at localhost or is running on its own server in the same farm. 

The ldap-authentication.properties file will need to be updated with jinja templating so that it can set different authentication groups for the client it is deployed for. 

branding.sls
===

Automatically detects if the server is "Europa", "Mars", or "Community" deployed. 

Based on this detection the branding is changed to follow their projects requests. 

This should be rewritten to use data from Pillers to make it more simple and clean. 

start.sls
===

Simple script used to restart the tomcat service. 


remove_old.sls:
===

Only ran manually. This will shutdown the tomcat service and remove the /opt/apache-tomcat/webapps/alfresco and share directories. 

This can be used for a "refresh" deployment. 
