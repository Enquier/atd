atd/salt_cfg
===

Salt Master Configuration files for Europa SaltStack System. 

**Currently Deployed to:** Europa AWS

**Server Farm:** EuropaAWS-SaltStack

**Server Name:** centos65-europa-prod-saltmaster

**Server IP:** 128.149.16.168

**Managed Under:** Scalr

**Role:** Production Salt Master Server for Europa Project.

**Versions:** 

 At the time of writing the following versions of Salt/SaltMinion were installed. 

 Salt-master: 2014.1.5-1

 Salt-minion: 2014.1.5-1

Make sure to avoid the 2014.1.7 release as it has issues with minions properly reconnecting. 

If available the 2014.1.8 release should be good/stable. (As of July 20, 2014)


Setup instructions for a new SaltMaster server. 
===

The following instructions can be used to create a new SaltMaster server for Europa (Or any project). 

1. Create a farm for your saltmaster on your Scalr installation. 
  1. Format should follow "customer-purpose". 
  2. ex. EuropaAWS-SaltStack

2. If key based authentication is required for your Git repository (github.jpl.nasa.gov)
  1. set the global variable “SCALR_GITKEY_SALT” in the Farm. 
  2. Click the “eye” icon to the right of the variable definition to make this key not visible at a lower scope  in scalr. 

3. Add a Role to the Farm. (Select the latest version of the OCIO minimal CentOS image — Prod). 
4. Set the Alias for the role you just added. 
  1. This should follow this format. “os/version-customer-environment-servertype” 
  2. An example: “centos65-europa-prod-saltmaster”

5. Select your instance size (Default to m1.large)
6. All other settings should remain default. 
7. Return to the “Farms” screen and launch your new salt farm. 
8. Once the farm has completed launching (check the “Servers” tab) continue with the next section. 

Default Paths you may find useful. 
===
* /etc/salt
* /etc/salt/top.sls
* /srv
* /opt/salt_git
* /var/log/salt
* /srv/large_files_store

Install EPEL/Remi if they are not already installed. 
===

```
cd /tmp
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm
```

Enable REMI repo. (Disabled by default). 
1. Modify /etc/yum.repos.d/remi.repo
2. Make sure that the top listing [remi] has "enabled=1" set. 
```
name=Les RPM de remi pour Enterprise Linux $releasever - $basearch
#baseurl=http://rpms.famillecollet.com/enterprise/$releasever/remi/$basearch/
mirrorlist=http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
failovermethod=priority
```

Install Updates and needed packages
```
yum update -y
```
Install git and Salt Master
```
yum install git salt-master salt -y
```
Enable salt-master to start at boot. 
```
chkconfig salt-master on
```

Checkout git-repo on new saltmaster host. 
=== 

Generate private/public keypair and add it to your github account
(from server)
``` 
ssh-keygen
```
Select default options unless you have any requirements you want to set. 

(On GitHub)
1. Navigate to your project, select “Settings” on the right side. 
2. Go to “Deploy Keys”
3. Click on “Add deploy key”
4. Give the key a title that is descriptive. 
5. Copy the contents of ~/.ssh/id_rsa.pub into the “Key” box on the github website. 
6. Click on the “Add Key” button.
7. When the prompt comes up, confirm your username/password to add the key. Github will send you an email notification to let you know the key was added. 

(from server)
 Test connectivity to github with your new key. 
```
ssh -T git@github.jpl.nasa.gov
```
Expected output should be similar to this:
```
  Hi USERNAME/atd! You've successfully authenticated, but GitHub does not provide shell access.
```
If your output is different, make sure you followed the above (On GitHub) steps properly. 

 Create a location to checkout the git repo. 
```
mkdir /opt/salt_git
```
 Checkout the git repository (If you need to checkout a different fork or repository make sure to edit the below line). 
```
git clone git@github.jpl.nasa.gov:weaklim/atd.git .
```

 Create SymLinks to default locations that salt uses for state files and configuration files. 
```
cd /opt/salt_git
mv /etc/salt /etc/salt_old
mv /srv /srv_old
ln -s /opt/salt_git/salt_cfg /etc/salt
ln -s /opt/salt_git/salt_states /srv
```

Update iptables and start salt-master
===

Add required iptables rules. 
In /etc/sysconfig/iptables
```
## SaltStack minion/master communication
-A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 4505 -j ACCEPT
-A JPL-INPUT-LOCAL-ACCEPT -p tcp -m state --state NEW -m tcp --dport 4506 -j ACCEPT
```

Restart iptables for change to take effect:
```
service iptables restart
```

Start salt-master:
```
service salt-master start
```

Connect salt-minions to this host. 
===

If you are connecting a not-launched server to this salt master. 
(From Scalr)
1. Open the farm configuration for the server you want to connect to this master. 
2. Modify the Global variable "SCALR_SALT_MASTER" to contain the IP address of your new saltmaster server. 
3. Launch the farm. This vairable is used to set an entry in /etc/hosts for the host "salt". 
4. Once the server/minion comes online it will attempt to connect to the new saltmaster server. 

If you are connecting an existing (turned on) server to this salt master. 
(From server)
Salt-minion's will always attempt to connect to the hostname "salt". We take advantage of this by setting an IP address for the hostname "salt" in the minion's /etc/hosts file. 
1. Modify the /etc/hosts file and update the entry for "salt" to be your new salt-master. 
2. Restart the salt-minion
```
service salt-minion restart
```
3. Your salt-minion should connect to the new salt-master automatically and will either auto-auth or be sitting in your "salt-keys" queue. 
Check this with (From salt-master):
```
salt-key
```

