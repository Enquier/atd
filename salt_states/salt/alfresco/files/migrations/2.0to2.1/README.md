* make sure to create following with all as collaborators
 * CompanyHome/commits
 * CompanyHome/Sites/snapshots
 * CompanyHome/Sites/Jobs
 * CompanyHome/Sites/no_site has EVERYONE as collaborator
* make sure that all the no_site, no_projects are changed to {sitename}_no_project, use javascript-console below to fix
```
function getSiteName(node) {
  if (node == null) {
    return "no_site";
  }
  if (node.getType().equals("{http://www.alfresco.org/model/site/1.0}site")) {
    return node.name;
  } else {
    return getSiteName(node.getParent())
  }
}


function main() {
	var nodes = search.luceneSearch("@sysml\\:id:no_project*");

	var sysml = "{http://jpl.nasa.gov/model/sysml-lite/1.0}";
	var id = "id";
	for each(var node in nodes) {
      var sysmlid = node.getProperties()[sysml+id];
      var sitename = getSiteName(node);
      var newid = sitename + "_" + sysmlid;
  	  logger.log(node.getDisplayPath());
      logger.log("  oldid: " + sysmlid);
      logger.log("  newid: " + newid);
      //node.getProperties()[sysml+id] = newid;
      //node.save();
	}
}

main();
```

## Following is only necessary if syncing from a new system
Apply LDAP configuration settings twice - copy from ems

```
%> rm $TOMCAT_HOME/shared/classes/alfresco/extension/license/alfresco_enterprise_license.lic.installed
%> cp ~cinyoung/git/atd/salt_states/salt/alfresco/files/alfresco_enterprise_license.lic $TOMCAT_HOME/shared/classes/alfresco/extension/license/.

# check that tomcat will load it properly

%> vim $TOMCAT_HOME/conf/catalina.properties

# check that the following line exists:

shared.loader=${catalina.base}/shared/classes

# get ready to migrate

%> sudo su
%> /etc/init.d/tomcat stop
%> /etc/init.d/postgresql-9.3 stop

# setup postgres for sync
%> cd /var/lib/pgsql/9.3/data
%> mv data backups/data_date_time
# change ownership to your user so you can rsync the data over
%> cd /var/lib
%> chown -R username:jpl pgsql

# on source system rsync to the target system
%> sudo su
%> cd /var/lib/pgsql/9.3
%> rsync -r data cinyoung@europaems-int.jpl.nasa.gov:/var/lib/pgsql/9.3

# back on target system
%> chown -R postgres:postgres pgsql


# now sync the alf_data
cd /mnt/alf_data
[root@europaems-int alf_data]$ mv bkps 2015_03_13
[root@europaems-int alf_data]$ mkdir 2015_03_27
[root@europaems-int alf_data]$ mv backup-lucene-indexes contentstore contentstore.deleted keystore lost+found lucene-indexes oouser 2015_03_27
[root@europaems-int alf_data]$ cd /mnt
[root@europaems-int mnt]$ chown -R cinyoung:jpl alf_data

# from source
 cd /mnt/alf_data/
 rsync -rv backup-lucene-indexes cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data
 rsync -rv contentstore.deleted cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data
 rsync -rv keystore cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data
 rsync -rv lost+found cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data
 rsync -rv oouser cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data
 rsync -rv lucene-indexes cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data
 rsync -rv contentstore cinyoung@europaems-int.jpl.nasa.gov:/mnt/alf_data

```
