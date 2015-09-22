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
    - pattern: "$rootScope.mms_footer = 'JPL/Caltech PROPRIETARY — Not for Public Release or Redistribution. No export controlled documents allowed on this server.';"
    - repl: "$rootScope.mms_footer = 'JPL/Caltech PROPRIETARY — Not for Public Release or Redistribution. No export controlled documents allowed on this server.';"
  
{% elif 'www' in grains['farm_name'] %}

 {# Update branding for community server #}
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
    - pattern: |
        $rootScope.mms_footer = 'JPL/Caltech PROPRIETARY — Not for Public Release or Redistribution. No export controlled documents allowed on this server.';
    - repl: |
        $rootScope.mms_footer = 'THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE';
    
{% endif %}

