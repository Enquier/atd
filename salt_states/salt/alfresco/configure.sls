{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco
# - alfresco.deploy

{% set admin_pass = pillar['alfresco_server_password'] %}
{% set admin_user = pillar['alfresco_server_user'] %}

{{ pillar['tomcat_home'] }}/shared/classes/alfresco-global.properties:
  file.managed:
    - source: salt://alfresco/files/alfresco-global.properties.default
    - template: jinja
    - user: tomcat
    - group: tomcat

{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' and grains['domain'] == 'nminc.co' %}
{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication/ldap/common-ldap-context.xml:
  file.managed:
    - source: salt://alfresco/files/common-ldap-context.xml.default
    - makedirs: True

{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication/ldap/ldap1/ldap-authentication.properties:
  file.managed:
    - source: salt://alfresco/files/ldap-authentication.properties-nminctest
    - makedirs: True

{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication/ldap/ldap1/ldap-authentication-context.xml:
  file.managed:
    - source: salt://alfresco/files/ldap-authentication-context.xml.default
    - makedirs: True

cp -rp {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/subsystems/Authentication/alfrescoNtlm {{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/subsystems/Authentication:
  cmd.run
{% endif %}

cp -rp {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/keystore /mnt/alf_data:
  cmd.run
  
set_admin_pass:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/module/view-repo/context/service-context.xml
    - pattern: |
        \${adminpassword}
    - repl: "{{ admin_pass }}"

set_admin_user:
   file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/module/view-repo/context/service-context.xml
    - pattern: |
        \${adminusername}
    - repl: "{{ admin_user }}"

update_tomcat_permissions:
  file.directory:
    - name: {{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group

update_alf_data_permissions:
  file.directory:
    - name: /mnt/alf_data
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
