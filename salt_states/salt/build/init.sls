{#
Salt Formula by Charles Galey cglaey@nomagic.com

#}

artifactory:
  pkg.installed:
    - sources:
	    - artifactory-3.9.2: https://bintray.com/artifact/download/jfrog/artifactory-rpms/artifactory-3.9.2.rpm
            	  
artifactory_startup:
  service:
    - dead
    - name: activemq
    - enable: True
    - onlyif: test ! -e /etc/init.d/artifactory
    - require:
        - pkg: artifactory-3.9.2
        - user: artifactory
        - group: artifactory