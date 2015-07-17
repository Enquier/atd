{#
Salt Formula by Charles Galey cglaey@nomagic.com

#}

artifactory:
  pkg.installed:
    - sources:
      - artifactory: https://bintray.com/artifact/download/jfrog/artifactory-rpms/artifactory-3.9.2.rpm

artifactory_startup:
  service:
    - dead
    - name: artifactory
    - enable: True
    - onlyif: test ! -e /etc/init.d/artifactory
    - require:
      - pkg: artifactory