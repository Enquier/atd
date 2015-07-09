adt/salt_states/srv/salt/mounted_dirs
==========

Salt formulas for mounting remote NFS shares required for /home and for alfresco data directorys. 

Also installs cachefs to cache NFS files to speed up user environments. 

Will also use a RamDisk as the cache location for NFS share files. 

init.sls
===

Installs all dependencies required to mount NFS shares on the salt-minion system. 

cachefs.sls
===

Installs the cachefs packages required to enable cacheing on NFS file shares. 

Sets the user_xattr propertiy on the filesystem being used to cache files. 

europa_nfs_alf_data.sls
===

Detects if the system is installed on AWS. If it is, mount the NFS volumes for the Europa project. (Can be updated to mount any project's NFS server). 

This will mount the DATA storage for the alfresco system. 

europa_nfs_homes:
===

Mounts NFS home directories for the developers for the Eurpa EMS project. 

Detects if you are on AWS before attempting to mount shares. 

If the alfresco license is set to "community" rather than "enterprise" a Local storage will be crated rather than a NFS stored system. 

