{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - alfresco
  - alfresco.copy  
  - alfresco.deploy

shutdown_tomcat:
  module.run:
    - order: 1
    - name: service.stop
    - m_name: tomcat

remove_old_alfresco:
  file.absent:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco

remove_old_alfresco_war:
  file.absent:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco.war

remove_old_share:
  file.absent:
    - name: {{ pillar['tomcat_home'] }}/webapps/share

remove_old_share.war:
  file.absent:
    - name: {{ pillar['tomcat_home'] }}/webapps/share.war

remove_zip_deployments:
  file.absent:
    - name: /usr/src/alfresco_deploy

{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}

remove_zip_file_ent:
  file.absent:
    - name: /tmp/alfresco-community.zip 

{% elif grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}
 
remove_zip_file_ent:
  file.absent:
    - name: /tmp/alfresco-enterprise.zip

{% endif %}
