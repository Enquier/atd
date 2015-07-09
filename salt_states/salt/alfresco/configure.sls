{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco
# - alfresco.deploy

/opt/local/apache-tomcat/shared/classes/alfresco-global.properties:
  file.managed:
    - source: salt://alfresco/files/alfresco-global.properties.default
    - template: jinja
    - user: tomcat
    - group: tomcat

{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}
/opt/local/apache-tomcat/shared/classes/alfresco/extension/subsystems/Authentication/ldap/common-ldap-context.xml:
  file.managed:
    - source: salt://alfresco/files/common-ldap-context.xml.default
    - makedirs: True

/opt/local/apache-tomcat/shared/classes/alfresco/extension/subsystems/Authentication/ldap/ldap1/ldap-authentication.properties:
  file.managed:
    - source: salt://alfresco/files/ldap-authentication.properties.default
    - makedirs: True

/opt/local/apache-tomcat/shared/classes/alfresco/extension/subsystems/Authentication/ldap/ldap1/ldap-authentication-context.xml:
  file.managed:
    - source: salt://alfresco/files/ldap-authentication-context.xml.default
    - makedirs: True

cp -rp /opt/local/apache-tomcat/webapps/alfresco/WEB-INF/classes/alfresco/subsystems/Authentication/alfrescoNtlm /opt/local/apache-tomcat/shared/classes/alfresco/extension/subsystems/Authentication:
  cmd.run
{% endif %}

cp -rp /opt/local/apache-tomcat/webapps/alfresco/WEB-INF/classes/alfresco/keystore /mnt/alf_data:
  cmd.run

update_tomcat_permissions:
  file.directory:
    - name: /opt/local/apache-tomcat/shared/classes/alfresco/extension
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
