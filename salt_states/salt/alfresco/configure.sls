{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco.amps_deploy

{{ pillar['tomcat_home'] }}/shared/classes/alfresco-global.properties:
  file.managed:
    - source: salt://alfresco/files/alfresco-global.properties.default
    - template: jinja
    - user: tomcat
    - group: tomcat
    - require:
      - sls: alfresco.amps_deploy

{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' and grains['domain'] == 'nminc.co.' %}
{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication/ldap-ad/common-ldap-context.xml:
  file.managed:
    - source: salt://alfresco/files/common-ldap-context.xml.default
    - template: jinja
    - makedirs: True
    - require:
      - sls: alfresco.amps_deploy

{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication/ldap-ad/ldap1/ldap-authentication.properties:
  file.managed:
    - source: salt://alfresco/files/ldap-authentication.properties-nminctest
    - makedirs: True
    - template: jinja
    - require:
      - sls: alfresco.amps_deploy

{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication/ldap-ad/ldap1/ldap-authentication-context.xml:
  file.managed:
    - source: salt://alfresco/files/ldap-authentication-context.xml.default
    - makedirs: True
    - template: jinja
    - require:
      - sls: alfresco.amps_deploy

cp -rp {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/subsystems/Authentication/alfrescoNtlm {{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication:
  cmd.run
{% endif %}

cp -rp {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/keystore /mnt/alf_data:
  cmd.run

update_tomcat_permissions:
  file.directory:
    - name: {{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
    - require:
      - sls: tomcat

update_alf_data_permissions:
  file.directory:
    - name: /mnt/alf_data
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
