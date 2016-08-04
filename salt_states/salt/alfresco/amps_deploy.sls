{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include: 
  - alfresco
  - tomcat
#  - alfresco.copy
#  - alfresco.deploy
{% if grains['node_env'] == 'prod' %}
  {% set release = 'release' %}
{% else %}
  {% set release = '' %}
{% endif %}

{% set mms_version = grains['MMS_RELEASE_VERSION'] %}
{% set alfresco_ver = grains['ALFRESCO_VERSION'] %}

{# 
copy the alfresco.war and share.war. the deploy script
currently expects there to be a .bak version of these files,
it will not run without the .bak versions. remove this if
the script installWar.sh is fixed to not expect a parameter
for this file
#}

copy_alfresco_war:
  cmd.run:
    - cwd: {{ pillar['tomcat_home'] }}/webapps
    - name: cp alfresco.war alfresco.war-`date +%s`.bak
    - require:
      - sls: tomcat

copy_share_war:
  cmd.run:
    - cwd: {{ pillar['tomcat_home'] }}/webapps
    - name: cp share.war share.war-`date +%s`.bak
    - require:
      - sls: tomcat
      
copy_deploy_scripts:
  file.recurse:
    - name: /tmp/atd/salt_states/salt/alfresco/files/scripts
    - source: salt://alfresco/files/scripts
    - clean: True
    - makedirs: True
    - template: jinja
    - user: tomcat
    - group: tomcat
    - file_mode: 755
    - recurse:
      - user
      - group

set_alf_version:
  file.blockreplace:
    - name: /tmp/atd/salt_states/salt/alfresco/files/scripts/redeployLatest.sh
    - marker_start: "###START ALFRESCO VERSION SET BY SALT DO NOT EDIT####"
    - marker_end: "####END ALFRESCO VERSION SET BY SALT DO NOT EDIT####"
    - content: "alf_ver={{ alfresco_ver }}"

deploy_script:    
  cmd.run:
    - cwd: /tmp/atd/salt_states/salt/alfresco/files/scripts
    - name: ./redeployLatest.sh {{ release }} {{ mms_version }}
    - user: root
    - group: root
    - require:
      - file: set_alf_version
      - file: copy_deploy_scripts
      - sls: tomcat

change_tomcat_ownership:
  file.directory:
    - name: {{ pillar['tomcat_home'] }}
    - user: tomcat
    - group: tomcat
    - makedirs: False
    - follow_symlinks=True
    - recurse:
      - user
      - group
    - require:
      - sls: tomcat

