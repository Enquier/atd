{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - alfresco

/opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl:
  file.managed:
    - source: salt://alfresco/files/branding/login.get.html.ftl.default

/opt/local/apache-tomcat/webapps/alfresco/scripts/vieweditor/images:
  file.directory:
    - user: tomcat
    - group: tomcat
    - makedirs: True

/opt/local/apache-tomcat/webapps/share/scripts/vieweditor/images:
  file.directory:    
    - user: tomcat
    - group: tomcat
    - makedirs: True

{% if 'nomagic' in grains['farm_name'] %}

 {# Update branding for nomagic server #}
turn_off_bg_image:
  file.replace:
    - name: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - path: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "var style = \"background-image: url(${url.context}/scripts/vieweditor/images/europa-bg.png)*"
    - repl: "//var style = \"background-image: url(${url.context}/scripts/vieweditor/images/europa-bg.png);"

disable_bg_color:
  file.replace:
    - name: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - path: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "elems\\[ii\\]\\.setAttribute*"
    - repl: "//elems[ii].setAttribute"

update_tile_box:
    file.replace:
    - path: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: '<b>  Europa EMS</b>'
    - repl: '<b>No Magic MBEA</b>'

/opt/local/apache-tomcat/webapps/alfresco/scripts/vieweditor/images/europa-icon.png:
  file.managed:
    - source: salt://alfresco/files/branding/No_Magic_logo.png
    - user: tomcat
    - group: tomcat

{% elif 'community' in grains['farm_name'] %}

 {# Update branding for community server #}
turn_off_bg_image:
  file.replace:
    - name: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - path: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "var style = \"background-image: url(${url.context}/scripts/vieweditor/images/europa-bg.png)*"
    - repl: "//var style = \"background-image: url(${url.context}/scripts/vieweditor/images/europa-bg.png);"

disable_bg_color:
  file.replace:
    - name: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - path: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: "elems\\[ii\\]\\.setAttribute*"
    - repl: "//elems[ii].setAttribute"

update_tile_box:
    file.replace:
    - path: /opt/local/apache-tomcat/webapps/share/WEB-INF/classes/alfresco/site-webscripts/org/alfresco/components/guest/login.get.html.ftl
    - pattern: '<b>  Europa EMS</b>'
    - repl: '<b>Community EMS</b>'

/opt/local/apache-tomcat/webapps/alfresco/scripts/vieweditor/images/europa-icon.png:
  file.managed:
    - source: salt://alfresco/files/branding/Community_EMS_Icon.png
    - user: tomcat
    - group: tomcat


{% endif %}

