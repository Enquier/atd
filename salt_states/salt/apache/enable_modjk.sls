{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{% if grains['farm_role_index'] == 1 %}

 {% set myURL = grains['farm_name'] %}

{% elif grains['farm_role_index'] == 2 %}

 {% set myURL = grains['farm_name']-b %}

{% endif %}

{% set myDomain = grains['domain'] %}

include:
 - apache
 - apache.mod_jk

update_httpd_modJk_LoadModule:
  file.blockreplace:
    - name: /etc/httpd/conf/httpd.conf
    - marker_start: '## START :: SALT :: mod_jk install. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk install. Do not edit Manually'
    - content: |
        #Load mod_jk apache-tomcat connector module
        LoadModule jk_module modules/mod_jk.so

{% if grains ['node_type'] == 'allinone' %}

update_httpd_modJk_WorkerSettings:
  file.blockreplace:
    - name: /etc/httpd/conf/httpd.conf
    - marker_start: '## START :: SALT :: mod_jk worker settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk worker settings. Do not edit Manually'
    - content: |
        # Settings required for mod_jk
        JkWorkersFile /etc/httpd/worker.properties
        # Where to put jk logs
        JkLogFile /var/log/httpd/mod_jk.log
        # Set the jk log level [debug/error/info]
        JkLogLevel info
        # Select the log format
        JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "
        # JkOptions indicate to send SSL KEY SIZE,
        JkOptions +ForwardKeySize -ForwardDirectories
        # JkRequestLogFormat set the request format
        JkRequestLogFormat "%w %V %T"
        # Send servlet for context /alfresco to your repository
        JkMount /share worker1
        JkMount /alfresco worker1
        # Send JSPs for context /alfresco/* to your repository
        JkMount /share/* worker1
        JkMount /alfresco/* worker1
        
update_httpd_ssl_modJk:
  file.blockreplace:
    - name: /etc/httpd/conf.d/ssl.conf
    - marker_start: '## START :: SALT :: mod_jk mountpoint settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk mountpoint settings. Do not edit Manually'
    - content: |
        ## Settings to allow alfresco to be served HTTPS. 
        JkMountCopy On
        JkMount /alfresco worker1
        JkMount /alfresco/* worker1
        JkMount /share worker1
        JkMount /share/* worker1
        ## ModRewrite rules. 
        RewriteEngine On
        RewriteCond %{REQUEST_URI} ^/$
        RewriteRule (.*) https://{{ myURL }}.{{ myDomain }}/alfresco/mmsapp/mms.html#/workspaces/master [NE,R=301,L]
        RewriteRule /alfresco/mmsapp/ve.html https://{{ myURL }}.{{ myDomain }}/alfresco/mmsapp/mms.html$1 [L]
        RewriteRule /alfresco/mmsapp/docweb.html https://{{ myURL }}.{{ myDomain }}/alfresco/mmsapp/mms.html$1 [L]
        RewriteRule /alfresco/mmsapp/portal.html https://{{ myURL }}.jpl.nasa.gov/alfresco/mmsapp/mms.html$1 [L]

update_workers_properties:
  file.blockreplace:
    - name: /etc/httpd/workers.properties
    - marker_start: '## START :: SALT :: mod_jk settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk settings. Do not edit Manually'
    - content: |
        workers.tomcat_home=/opt/apache-tomcat/
        workers.java_home=/opt/jre
        ps=/
        worker.list=worker1

        worker.default.port=8009
        worker.default.host=localhost
        worker.default.type=ajp13
        worker.default.lbfactor=1

{% elif grains ['node_type'] == 'build' %}
update_httpd_modJk_WorkerSettings:
  file.blockreplace:
    - name: /etc/httpd/conf/httpd.conf
    - marker_start: '## START :: SALT :: mod_jk worker settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk worker settings. Do not edit Manually'
    - content: |
        # Settings required for mod_jk
        JkWorkersFile /etc/httpd/workers.properties
        # Where to put jk logs
        JkLogFile /var/log/httpd/mod_jk.log
        # Set the jk log level [debug/error/info]
        JkLogLevel info
        # Select the log format
        JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "
        # JkOptions indicate to send SSL KEY SIZE,
        JkOptions +ForwardKeySize -ForwardDirectories
        # JkRequestLogFormat set the request format
        JkRequestLogFormat "%w %V %T"
        # Send servlet for context /artifactory to your repository
        JkMount /artifactory worker1
        # Send JSPs for context /artifactory/* to your repository
        JkMount /artifactory/* worker1
        
update_httpd_ssl_modJk:
  file.blockreplace:
    - name: /etc/httpd/conf.d/ssl.conf
    - marker_start: '## START :: SALT :: mod_jk mountpoint settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk mountpoint settings. Do not edit Manually'
    - content: |
        ## Settings to allow artifactory to be served HTTPS. 
        JkMountCopy On
        JkMount /artifactory worker1
        JkMount /artifactory/* worker1
        ## ModRewrite rules. 
        RewriteEngine On
        RewriteCond %{REQUEST_URI} ^/$
        RewriteRule (.*) https://{{ myURL }}.{{ myDomain }}/artifactory [NE,R=301,L]

update_workers_properties:
  file.blockreplace:
    - name: /etc/httpd/workers.properties
    - marker_start: '## START :: SALT :: mod_jk settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: mod_jk settings. Do not edit Manually'
    - content: |
        workers.tomcat_home=/opt/jfrog/artifactory/tomcat/
        workers.java_home=/opt/jre
        ps=/
        worker.list=worker1

        worker.default.port=8019
        worker.default.host=localhost
        worker.default.type=ajp13
        worker.default.lbfactor=1
        


{% endif %}