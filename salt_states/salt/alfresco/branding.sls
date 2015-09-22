{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - alfresco

{{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl:
  file.managed:
    - source: salt://alfresco/files/branding/login.get.html.ftl.default

{{ pillar['tomcat_home'] }}/webapps/alfresco/scripts/vieweditor/images:
  file.directory:
    - user: tomcat
    - group: tomcat
    - makedirs: True

{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images:
  file.directory:    
    - user: tomcat
    - group: tomcat
    - makedirs: True

{% if 'ea' in grains['farm_name'] %}

 {# Update branding for nomagic server #}

disable_bg_color:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "elems\\[ii\\]\\.setAttribute*"
    - repl: "//elems[ii].setAttribute"

update_tile_box:
    file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: '<b>  EMS</b>'
    - repl: '<b>No Magic Model Based Enterprise Architecture</b>'

{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images/icon.png:
  file.managed:
    - source: salt://alfresco/files/branding/No_Magic_logo.png
    - replace: True
    - user: tomcat
    - group: tomcat
    
{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images/bg.png:
  file.managed:
    - source: salt://alfresco/files/branding/openmbee.png
    - replace: True
    - user: tomcat
    - group: tomcat
    
fix_mmsapp_footer:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers/main.controller.js
    - path: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers/main.controller.js
    - pattern: "$rootScope.mms_footer = 'The technical data in this document is controlled under the U.S. Export Regulations, release to foreign persons may require an export authorization.';"
    - repl: "$rootScope.mms_footer = 'THE TECHNICAL DATA IN THIS DOCUMENT IS NO MAGIC INC PROPRIETARY AND CONFIDENTIAL; DO NOT DISTRIBUTE WITHOUT PRIOR AUTHORIZATION';"
  
{% elif 'openmbee' in grains['farm_name'] %}

 {# Update branding for community server #}
turn_off_bg_image:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - path: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "var style = \"background-image: url(${url.context}/scripts/vieweditor/images/europa-bg.png)*"
    - repl: "//var style = \"background-image: url(${url.context}/scripts/vieweditor/images/europa-bg.png);"

disable_bg_color:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - path: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "elems\\[ii\\]\\.setAttribute*"
    - repl: "//elems[ii].setAttribute"

update_tile_box:
    file.replace:
    - path: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: '<b>  EMS</b>'
    - repl: '<b>OpenMBEE Community/b>'

{{ pillar['tomcat_home'] }}/webapps/alfresco/scripts/vieweditor/images/icon.png:
  file.managed:
    - source: salt://alfresco/files/branding/OPENMBEE_LOGO_SMALL.png
    - user: tomcat
    - group: tomcat

fix_mmsapp_footer:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers/main.controller.js
    - path: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers/main.controller.js
    - pattern: "$rootScope.mms_footer = 'The technical data in this document is controlled under the U.S. Export Regulations, release to foreign persons may require an export authorization.';"
    - repl: "$rootScope.mms_footer = 'THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE';"
    
{% endif %}

