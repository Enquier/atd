{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - alfresco
# - mounted_dirs
# - mounted_dirs.europa_nfs_alf_data

{% set environment = grains['node_env'] %}
{% set tomcat_home = pillar['tomcat_home'] %}
{% set alf_type = grains['ALFRESCO_LICENSE_TYPE'] %}
{% if grains['ALFRESCO_LICENSE_TYPE'] == 'community' %}
  {% set edition = "alfresco-community" %}
{% elif grains['ALFRESCO_LICENSE_TYPE'] == 'enterprise' %}
  {% set edition = "alfresco-enterprise" %}
{% endif %}

{% if 1 == salt['cmd.retcode']('test -e tomcat_home/webapps/alfresco.war') %}
alfresco_copy_bins:
  file.recurse:
    - name: {{ pillar['tomcat_home'] }}/bin
    - source: salt://alfresco/files/{{ edition }}/bin

alfresco_copy_licenses:
  file.recurse:
    - name: {{ pillar['tomcat_home'] }}/licenses
    - source: salt://alfresco/files/{{ edition }}/licenses

alfresco_copy_endorsed:
  file.recurse:
    - name: {{ pillar['tomcat_home'] }}/endorsed
    - source: salt://alfresco/files/{{ edition }}/web-server/endorsed

alfresco_copy_lib:
  file.recurse:
    - name: {{ pillar['tomcat_home'] }}/lib
    - source: salt://alfresco/files/{{ edition }}/web-server/lib

alfresco_copy_shared:
  file.recurse:
    - name: {{ pillar['tomcat_home'] }}/shared
    - source: salt://alfresco/files/{{ edition }}/web-server/shared

alfresco_copy_webapps:
  file.recurse:
    - name: {{ pillar['tomcat_home'] }}/webapps
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
{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/license:
  file.directory:
    - user: tomcat
    - group: tomcat
    - makedirs: True

{{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/license/alfresco_enterprise_license.lic:
  file.managed:
    - source: salt://alfresco/files/alfresco_enterprise_license.lic
    - user: tomcat
    - group: tomcat
    - onlyif:  test ! -e {{ pillar['tomcat_home'] }}/shared/classes/alfresco/extension/license/alfresco_enterprise_license.lic.installed 

{% endif %}

update_permissions:
  file.directory:
    - name: {{ pillar['tomcat_home'] }}
    - user: tomcat
    - group: tomcat
    - makedirs: False
    - recurse:
      - user
      - group
