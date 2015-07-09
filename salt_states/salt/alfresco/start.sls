{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco
# - alfresco.deploy
# - alfresco.decompress_war
# - alfresco.configure

start_httpd:
  module.run:
    - name: service.restart
    - m_name: httpd

start_tomcat:
  module.run:
    - name: service.restart
    - m_name: tomcat


