{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
{% set alf_ver = grains['ALFRESCO_VERSION'] %}
{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}

alfresco_zip_unpack:
  archive.extracted:
    - name: /usr/src/alfresco_deploy
    - source: salt://alfresco/files/alfresco-community-{{ alf_ver }}.zip
    - archive_format: zip
    - onlyif: test ! -e {{ pillar['tomcat_home'] }}/webapps/alfresco.war

{% elif grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}

alfresco_zip_unpack:
  archive.extracted:
    - name: /usr/src/alfresco_deploy
    - source: salt://alfresco/files/alfresco-enterprise-{{ alf_ver }}.zip
    - archive_format: zip
    - onlyif: test ! -e {{ pillar['tomcat_home'] }}/webapps/alfresco.war

{% endif %}

