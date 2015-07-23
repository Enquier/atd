{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

extract_maven:
  archive:
    - extracted
    - name: /opt/local
    - source: http://mirror.cogentco.com/pub/apache/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
    - archive_format: tar
    - if_missing: /opt/local/apache-maven-3.3.3
    - source_hash: md5=794b3b7961200c542a7292682d21ba36

add_mvn_to_path:
  alternatives.install:
    - name: mvn
    - link: /usr/bin/mvn
    - path: /opt/local/apache-maven-3.3.3/bin/mvn
    - priority: 50


add_mvnDebug_to_path:
  alternatives.install:
    - name: mvnDebug
    - link: /usr/bin/mvnDebug
    - path: /opt/local/apache-maven-3.3.3/bin/mvnDebug
    - priority: 50


add_mvnyjp_to_path:
  alternatives.install:
    - name: mvnyjp
    - link: /usr/bin/mvnyjp
    - path: /opt/local/apache-maven-3.3.3/bin/mvnyjp
    - priority: 50
    
add_maven_symlink:
  file.symlink:
    - name: /opt/local/apache-maven
    - target: /opt/local/apache-maven-3.3.3

mvn_env_vars:
  file.append:
    - name: /etc/profile.d/maven.sh
    - text:
      - export M2_HOME=/opt/local/maven
      - export PATH=${M2_HOME}/bin:${PATH}