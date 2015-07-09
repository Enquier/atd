{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco
 - mounted_dirs
# - mounted_dirs.europa_nfs_alf_data

{% set farm = grains['farm_name'] %}
{% set environment = grains['node_env'] %}
{% set alf_type = grains['ALFRESCO_LICENSE_TYPE'] %}
{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}
  {% set edition = "alfresco-community" %}
{% elif grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}
  {% set edition = "alfresco-enterprise" %}
{% endif %}

{% if 1 == salt['cmd.retcode']('test -f /opt/local/apache-tomcat/webapps/alfresco.war') %}
alfresco_copy_bins:
  file.recurse:
    - name: /opt/local/apache-tomcat/bin
    - source: salt://alfresco/files/{{ edition }}/bin

alfresco_copy_licenses:
  file.recurse:
    - name: /opt/local/apache-tomcat/licenses
    - source: salt://alfresco/files/{{ edition }}/licenses

alfresco_copy_endorsed:
  file.recurse:
    - name: /opt/local/apache-tomcat/endorsed
    - source: salt://alfresco/files/{{ edition }}/web-server/endorsed

alfresco_copy_lib:
  file.recurse:
    - name: /opt/local/apache-tomcat/lib
    - source: salt://alfresco/files/{{ edition }}/web-server/lib

alfresco_copy_shared:
  file.recurse:
    - name: /opt/local/apache-tomcat/shared
    - source: salt://alfresco/files/{{ edition }}/web-server/shared

alfresco_copy_webapps:
  file.recurse:
    - name: /opt/local/apache-tomcat/webapps
    - source: salt://alfresco/files/{{ edition }}/web-server/webapps
{% endif %}

/mnt/alf_data:
  file.directory:
    - makedirs: True

update_owners:
  cmd.run:
    - cwd: /mnt
    - name: chown -R tomcat:tomcat /mnt/alf_data


{% if grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}
/opt/local/apache-tomcat/shared/classes/alfresco/extension/license:
  file.directory:
    - user: tomcat
    - group: tomcat
    - makedirs: True

/opt/local/apache-tomcat/shared/classes/alfresco/extension/license/alfresco_enterprise_license.lic:
  file.managed:
    - source: salt://alfresco/files/alfresco_enterprise_license.lic
    - user: tomcat
    - group: tomcat
    - onlyif:  test ! -e /opt/local/apache-tomcat/shared/classes/alfresco/extension/license/alfresco_enterprise_license.lic.installed 

{% endif %}

update_permissions:
  file.directory:
    - name: /opt/local/apache-tomcat
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
