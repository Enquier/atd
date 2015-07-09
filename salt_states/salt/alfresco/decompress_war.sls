{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco
# - alfresco.deploy

decompress_alfresco:
  module.run:
    - name: archive.unzip
    - zipfile: /opt/local/apache-tomcat/webapps/alfresco.war
    - options: u
    - dest: /opt/local/apache-tomcat/webapps/alfresco
    - onlyif: test ! -e /opt/local/apache-tomcat/webapps/alfresco

decompress_alfresco_share:
  module.run:
    - name: archive.unzip
    - zipfile: /opt/local/apache-tomcat/webapps/share.war
    - options: u
    - dest: /opt/local/apache-tomcat/webapps/share
    - onlyif: test ! -e /opt/local/apache-tomcat/webapps/share

