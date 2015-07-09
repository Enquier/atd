{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include: 
  - alfresco
#  - alfresco.copy
#  - alfresco.deploy

{% set mms_version = grains['MMS_RELEASE_VERSION'] %}

{# 
copy the alfresco.war and share.war. the deploy script
currently expects there to be a .bak version of these files,
it will not run without the .bak versions. remove this if
the script installWar.sh is fixed to not expect a parameter
for this file
#}

copy_alfresco_war:
  cmd.run:
    - cwd: /opt/local/apache-tomcat/webapps
    - name: cp alfresco.war alfresco.war-`date +%s`.bak

copy_share_war:
  cmd.run:
    - cwd: /opt/local/apache-tomcat/webapps
    - name: cp share.war share.war-`date +%s`.bak

run_deploy_script:
  cmd.run:
    - cwd: /tmp/atd/salt_states/salt/alfresco/files/scripts
    - name: ./redeployLatest.sh {{ mms_version }}

change_tomcat_ownership:
  file.directory:
    - name: /opt/local/apache-tomcat
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group

