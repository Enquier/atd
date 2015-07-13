{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
{% set alf_ver = grains['ALFRESCO_VERSION'] %}
{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}

alfresco_zip_unpack:
  module.run:
    - name: archive.unzip
    - zipfile: /tmp/alfresco-community-{{ alf_ver }}.zip
    - options: u
    - dest: /usr/src/alfresco_deploy
    - onlyif: test ! -e /opt/local/apache-tomcat/webapps/alfresco.war
    - require:
      - file: /tmp/alfresco-community-{{ alf_ver }}.zip

/tmp/alfresco-community-{{ alf_ver }}.zip:
  file.managed:
    - order: 1
    - source: salt://alfresco/files/alfresco-community-{{ alf_ver }}.zip
    - user: root
    - group: root
    - mode: 644
    - replace: False

{% elif grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}

alfresco_zip_unpack:
  module.run:
    - name: archive.unzip
    - zipfile: /tmp/alfresco-enterprise-{{ alf_ver }}.zip
    - options: u
    - dest: /usr/src/alfresco_deploy
    - onlyif: test ! -e /opt/local/apache-tomcat/webapps/alfresco.war
    - require:
      - file: /tmp/alfresco-enterprise-{{ alf_ver }}.zip

/tmp/alfresco-enterprise-{{ alf_ver }}.zip:
  file.managed:
    - order: 1
    - source: salt://alfresco/files/alfresco-enterprise-{{ alf_ver }}.zip
    - user: root
    - group: root
    - mode: 644
    - replace: False

{% endif %}

