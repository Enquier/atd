{#
Salt Formula by Charles Galey cglaey@nomagic.com

#}
include:
  - tomcat
  
artifactory:
  archive.extracted:
    - name: /opt/src/
    - source: https://bintray.com/artifact/download/jfrog/artifactory/artifactory-3.9.2.zip
    - source_hash: sha1=245aeb7b2d77830462067d5a19c3bd32ae014ddf
    - archive_format: zip
    - if_missing: /opt/src/artifactory-3.9.2/    

copy_artifactory_war:
  file.copy:
    - name: {{ pillar['tomcat_home'] }}/webapps/artifactory.war
    - source: /opt/src/artifactory-3.9.2/webapps/artifactory.war
    - user: tomcat
    - group: tomcat
    - require:
      - archive: artifactory

{{ pillar['tomcat_home'] }}/webapps/jenkins.war:
  file.managed:
    - source: salt://build/files/jenkins.war
    - user: tomcat
    - group: tomcat
    
/var/opt/jfrog/artifactory:
  file.directory:
    - makedirs: True
    - user: tomcat
    - group: tomcat
    
/var/opt/jenkins:
  file.directory:
    - makedirs: True
    - user: tomcat
    - group: tomcat

configure_build_env:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: configure_build_env Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: configure_build_env Generated Automatically DO NOT EDIT!!###"
    - content: |
        export JAVA_OPTS="$JAVA_OPTS -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true" 
        export JAVA_OPTS="$JAVA_OPTS -Djruby.compile.invokedynamic=false -Dfile.encoding=UTF8"
        export CATALINA_OPTS="-Dartifactory.home=/var/opt/jfrog/artifactory"
        export CATALINA_OPTS="$CATALINA_OPTS -DJENKINS_HOME=/var/opt/jenkins"
    - require:
      - file: /var/opt/jenkins
      - file: /var/opt/jfrog/artifactory