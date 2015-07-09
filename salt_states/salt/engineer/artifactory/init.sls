{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - maven

/tmp/artifactory-3.3.0.rpm:
  file.managed:
    - source: salt://artifactory/files/artifactory-3.3.0.rpm

artifactory_install:
  cmd.run:
    - cwd: /tmp/
    - name: rpm -Uvh /tmp/artifactory-3.3.0.rpm
    - onlyif: test ! -e /opt/jfrog

/opt/jfrog/artifactory/tomcat/conf/server.xml:
  file.managed:
    - source: salt://artifactory/files/server.xml.default

/opt/jfrog/artifactory/misc/ha/ha-node.properties.template:
  file.managed:
    - source: salt://artifactory/files/ha-node.properties.template.default

/opt/local/apache-maven-3.2.2/settings.xml:
  file.managed:
    - source: salt://artifactory/files/maven_settings.xml.default
