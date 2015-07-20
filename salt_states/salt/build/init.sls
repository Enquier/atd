{#
Salt Formula by Charles Galey cglaey@nomagic.com

#}
include:
  - tomcat
  
artifactory:
  archive.extracted:
    - name: /opt/src/
    - source: https://bintray.com/artifact/download/jfrog/artifactory/artifactory-3.9.2.zip
    - archive_format: zip
    - if_missing: /opt/src/artifactory-3.9.2/
    
    

copy_artifactory_war:
  file.copy:
    - name: /opt/src/artifactory-3.9.2/webapps/artifactory.war
    - user: tomcat
    - group: tomcat
    



/opt/apache-tomcat/webapps/jenkins.war:
  file.managed:
    - source: https://updates.jenkins-ci.org/download/war/1.620/jenkins.war
    - user: tomcat
	  - group: tomcat
    
/var/opt/jfrog/artifactory:
  file.directory:
    - user: tomcat
    - group: tomcat
    
/var/opt/jenkins:
  file.directory:
    - user: tomcat
    - group: tomcat

configure_build_env:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: configure_jenkins_env Generated Automatically DO NOT EDIT!!###"
    - maker_end: "### END :: SALT :: configure_jenkins_env Generated Automatically DO NOT EDIT!!###"
    - content: |
        export JAVA_OPTS="$JAVA_OPTS -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true" 
        export JAVA_OPTS="$JAVA_OPTS -Djruby.compile.invokedynamic=false -Dfile.encoding=UTF8"
        ARTIFACTORY_HOME=/var/opt/jfrog/artifactory
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /var/opt/jenkins
      - file: /var/opt/jfrog/artifactory
      - file: /opt/local/apache-tomcat/bin/setenv.sh