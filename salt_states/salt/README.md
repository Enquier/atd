adt/salt_states/salt
==========

This folder is the primary location for Salt Formulas. 

The location is defined using the "file_roots" function in /etc/salt/master.d/environments.conf

This directory currently contains the "Base" and "Engineer" environments. 

The default location for Salt Formulas is /srv/salt

"Large Files" that are not in github or files that contain license or confidential information are by-default in the ".gitignore" file listing. These files will need to be manually copied over to the SaltMaster if you build a new salt-master. 

Please check against the list in the top level .gitignore file to make sure you are aware of missing files. This will cause errors when attempting to deploy a new system if it is not fixed. 

Add any files you wish to be excluded from github to the .gitignore file. Then copy that file over the "githubignore.default" file that will be added to the repostitory for convience in future deployments. 

Public documentation with SaltStack "file_roots" is available at: http://docs.saltstack.com/en/latest/ref/file_server/file_roots.html


Environments Definitions:
===

When defining a file_root you can specify multiple environments and locations for that environment to access files. See below for examples. 

This is done in the /etc/salt/master.d/environments.conf file. It is possible to place this directly in the salt-master configuration file (/etc/salt/master) but using the master.d folder for overrides follows best-practices and is highly encouraged. 

/etc/salt/master.d/environments.conf
```
file_roots:
  base:
    - /srv/salt
    - /srv/salt/large_files_store
  engineer:
    - /srv/salt/engineer
    - /srv/salt/large_files_store

```

Understanding file_roots:
===

When looking at the above example please remember that spacing is important. SaltStack follows a basic python-like whitespace ruleset. 

When the SaltMaster reads the "file_roots:" defnintion it will set each location for each environment as that environments "root" directory. This can be thought of as the environments "/" or chroot. 

This means that if you reference the location in a salt formula (state/piller/reactor/etc...) that any sub directory is accessed as a path relitive to "/srv/salt" or your other "top level" file_roots environment definition. 

As you can see above there is more than one "root" definition for each environment. The salt-master will attempt to find any file revelant to the state/formula in the first directory listed. If the salt-master is unable to locate the file it will then attempt to find it in the second (or thrid, fourth, etc...) directory.

This is limited to the environment defined. The SaltMaster will not attempt to find files for the "base" environment in the "engineer" environment unless directly specified to do so.  

By following the exact same folder structure in the "/srv/salt" and "/srv/salt/large_files_store" directorys the salt-master will easily be able to access all files needed even if they are not in the primary github account (See below for examples as to how these files are accessed). 

Example accessing a file in /srv/salt or /srv/salt/large_files_store.
===

This example is in the file /srv/salt/sshd/init.sls state file. Please see the next section to understand how saltstack interpreates "init.sls".  

The following example references a default "banner" that we want to be deployed to ALL hosts (the state file init.sls is defined in the "base" environment on the top.sls file. More on this later. 

/srv/salt/sshd/init.sls (July 19, 2014 Ian Weaklim)
```
openssh-server:
  pkg: 
   - installed
   - name: openssh-server
  service:
   - name: sshd
   - running
   - enable: True
   - reload: True
   - watch:
     - file: /etc/ssh/sshd_config
     - file: /etc/ssh/sshd-banner

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://sshd/files/sshd_config.default
    - user: root
    - group: root

/etc/ssh/sshd-banner:
  file.managed:
    - source: salt://sshd/files/sshd-banner.default
    - user: root
    - group: root
```

In the above example for "/etc/ssh/sshd-banner" we look to the "- source:" definition. 

```
 - source: salt://sshd/files/sshd-banner.default
```

As previously defined the file "sshd-banner.default" is located in the absolute path of "/srv/salt/sshd/files". 

The location of the sshd-banner.default file is relitive to the path "/srv/salt". As the directory "/srv/salt" is defined as a root to our environment it is accessable under the relititive path of "sshd/files/". 

As such, the file's new absolute path (as the salt-master sees it) is "sshd/files/sshd-banner.default". 

The definition of the file (top line) "/etc/ssh/sshd-banner:" will be the name of the file when it is deployed to the remote salt-minion. This is also considiered the "ID" of the file.  

The files User and group can be specified using the "- user:" and "- group:" definitions. 

If this files size is larger than 100MB it should be located under /srv/salt/large_files_store. This is because it is against best-practices to put large files into github as it can cause odd issues with the versioning system.  

By following the example "environments.conf" definition and by keeping the directory structure identical in /srv/salt and /srv/salt/large_files_store you are able to access files using the exact same "relitive" path in state/piller/etc files without having to directly specifiy that the file is in /srv/salt or in /srv/salt/large_files_store. 

This serves to simplify file access when writing formulas. 


Understanding init.sls naming:
===

Not all state files are named for what their purpose is. 

For example. Look at /srv/salt/sshd/init.sls. 

One would expect to see a defintion in the /srv/salt/top.sls file for "sshd.init". However, this is not the case. 

The init.sls file carries a special naming convention. It will inherit its name from the directory that it is placed in. For our pruposes the "/srv/salt/sshd/init.sls" file will be known as "sshd" for the salt-master. 

If other files exist in the "/srv/salt/sshd" directory such as "configure.sls" it will inherate the top level directory name as well. 

If this were to be defined in the "top.sls" file, it would look like "sshd.configure". 


