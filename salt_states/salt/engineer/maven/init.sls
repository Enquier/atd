{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

extract_maven:
  archive:
    - extracted
    - name: /opt/local
    - source: http://apache.mirrors.hoobly.com/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
    - archive_format: tar
    - if_missing: /opt/local/apache-maven-3.2.2
    - source_hash: md5=87e5cc81bc4ab9b83986b3e77e6b3095

add_mvn_to_path:
  alternatives.install:
    - name: mvn
    - link: /usr/bin/mvn
    - path: /opt/local/apache-maven-3.2.2/bin/mvn
    - priority: 50


add_mvnDebug_to_path:
  alternatives.install:
    - name: mvnDebug
    - link: /usr/bin/mvnDebug
    - path: /opt/local/apache-maven-3.2.2/bin/mvnDebug
    - priority: 50


add_mvnyjp_to_path:
  alternatives.install:
    - name: mvnyjp
    - link: /usr/bin/mvnyjp
    - path: /opt/local/apache-maven-3.2.2/bin/mvnyjp
    - priority: 50
