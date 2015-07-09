{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}

alfresco_zip_unpack:
  module.run:
    - name: archive.unzip
    - zipfile: /tmp/alfresco-community-4.2.e.zip
    - options: u
    - dest: /usr/src/alfresco_deploy
    - onlyif: test ! -e /opt/local/apache-tomcat/webapps/alfresco.war
    - require:
      - file: /tmp/alfresco-community-4.2.e.zip

/tmp/alfresco-community-4.2.e.zip:
  file.managed:
    - order: 1
    - source: salt://alfresco/files/alfresco-community-4.2.e.zip
    - user: root
    - group: root
    - mode: 644
    - replace: False

{% elif grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}

alfresco_zip_unpack:
  module.run:
    - name: archive.unzip
    - zipfile: /tmp/alfresco-enterprise-4.2.2.zip
    - options: u
    - dest: /usr/src/alfresco_deploy
    - onlyif: test ! -e /opt/local/apache-tomcat/webapps/alfresco.war
    - require:
      - file: /tmp/alfresco-enterprise-4.2.2.zip

/tmp/alfresco-enterprise-4.2.2.zip:
  file.managed:
    - order: 1
    - source: salt://alfresco/files/alfresco-enterprise-4.2.2.zip
    - user: root
    - group: root
    - mode: 644
    - replace: False

{% endif %}

