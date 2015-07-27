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
    - zipfile: {{ pillar['tomcat_home'] }}/webapps/alfresco.war
    - options: u
    - dest: {{ pillar['tomcat_home'] }}/webapps/alfresco
    - onlyif: test ! -e {{ pillar['tomcat_home'] }}/webapps/alfresco

decompress_alfresco_share:
  module.run:
    - name: archive.unzip
    - zipfile: {{ pillar['tomcat_home'] }}/webapps/share.war
    - options: u
    - dest: {{ pillar['tomcat_home'] }}/webapps/share
    - onlyif: test ! -e {{ pillar['tomcat_home'] }}/webapps/share

