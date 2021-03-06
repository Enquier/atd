{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - alfresco.deploy
  - alfresco.amps_deploy
  - alfresco.configure
  - tomcat

{{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl:
  file.managed:
    - source: salt://alfresco/files/branding/login.get.html.ftl.default
    - template: jinja

{{ pillar['tomcat_home'] }}/webapps/alfresco/scripts/vieweditor/images:
  file.directory:
    - user: tomcat
    - group: tomcat
    - makedirs: True
    - require:
      - sls: tomcat

{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images:
  file.directory:    
    - user: tomcat
    - group: tomcat
    - makedirs: True
    - require:
      - sls: tomcat

fix_share_footer:
  file.managed:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/footer/footer.get_en.properties
    - source: salt://alfresco/files/branding/footer.get_en.properties.default
    - replace: True
    - user: tomcat
    - group: tomcat

{% if grains['farm_name'] == 'ea' %}

 {# Update branding for nomagic server #}

disable_bg_color:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "elems\\[ii\\]\\.setAttribute*"
    - repl: "//elems[ii].setAttribute"
    - require:
      - sls: alfresco.amps_deploy

{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images/icon.png:
  file.managed:
    - source: salt://alfresco/files/branding/No_Magic_logo.png
    - replace: True
    - user: tomcat
    - group: tomcat
    - require:
      - sls: alfresco.amps_deploy

{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images/bg.png:
  file.managed:
    - source: salt://alfresco/files/branding/openmbee.png
    - replace: True
    - user: tomcat
    - group: tomcat
    - require:
      - sls: alfresco.amps_deploy
    
fix_mmsapp_main_footer:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers/main.controller.js
    - pattern: |
        \$rootScope.mms_footer = '.*';
    - repl: |
        $rootScope.mms_footer = 'No Magic Inc CONFIDENTIAL * Not for Public Release or Redistribution';
    - require:
      - sls: alfresco.amps_deploy

fix_mmsapp_footer:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers.js
    - pattern: |
        \$rootScope.mms_footer = '.*';
    - repl: |
        $rootScope.mms_footer = 'No Magic Inc CONFIDENTIAL * Not for Public Release or Redistribution';
    - require:
       - sls: alfresco.amps_deploy

          
{% elif 'www' in grains['farm_name'] %}

 {# Update branding for community server #}
disable_bg_color:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/share/WEB-INF/classes/alfresco/web-extension/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "elems\\[ii\\]\\.setAttribute*"
    - repl: "//elems[ii].setAttribute"
    - require:
      - sls: alfresco.amps_deploy

{{ pillar['tomcat_home'] }}/webapps/alfresco/scripts/vieweditor/images/icon.png:
  file.managed:
    - source: salt://alfresco/files/branding/OPENMBEE_LOGO_SMALL.png
    - user: tomcat
    - group: tomcat
    - require:
      - sls: alfresco.amps_deploy
    
{{ pillar['tomcat_home'] }}/webapps/share/scripts/vieweditor/images/bg.png:
  file.managed:
    - source: salt://alfresco/files/branding/openmbee.png
    - replace: True
    - user: tomcat
    - group: tomcat
    - require:
      - sls: alfresco.amps_deploy
    
fix_mmsapp_main_footer:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers/main.controller.js
    - pattern: |
        \$rootScope.mms_footer = '.*';
    - repl: |
        $rootScope.mms_footer = 'THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE';
    - require:
      - sls: alfresco.amps_deploy

fix_mmsapp_footer:
  file.replace:
    - name: {{ pillar['tomcat_home'] }}/webapps/alfresco/mmsapp/js/mms/controllers.js
    - pattern: |
        \$rootScope.mms_footer = '.*';
    - repl: |
        $rootScope.mms_footer = 'THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE';
    - require:
      - sls: alfresco.amps_deploy
    
{% endif %}

