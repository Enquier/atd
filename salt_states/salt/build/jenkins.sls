jenkins:
  pkgrepo.managed:
	- humanname: Jenkins
	- baseurl: http://pkg.jenkins-ci.org/redhat
	- gpgcheck: 1
	- key_url: https://jenkins-ci.org/redhat/jenkins-ci.org.key
  pkg.latest:
    - name: jenkins
	- fromrepo: jenkins
 