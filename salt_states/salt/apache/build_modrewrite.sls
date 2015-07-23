{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{% if grains['farm_role_index'] == 1 %}

 {% set myURL = grains['farm_name'] %}

{% elif grains['farm_role_index'] == 2 %}

 {% set myURL = grains['farm_name']-b %}

{% endif %}

{% set myDomain = grains['domain' ] %}
include:
  - apache
  - apache.mod_jk
  - apache.enable_modjk

update_httpd_modRewrite:
  file.blockreplace:
    - name: /etc/httpd/conf/httpd.conf
    - marker_start: '## START :: SALT :: Alfresco mod_rewrite settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: Alfresco mod_rewrite settings. Do not edit Manually'
    - content: |
        ## Rewrite rules
        #####################
        ##RewriteEngine On
        ##RewriteCond %{REQUEST_URI} ^/$
        ##RewriteCond %{lowercase:%{HTTP_HOST}} ^jenkins\.{{ myDomain }}$
        ##RewriteRule (.*) https://{{ myURL }}.{{ myDomain }}/jenkins [NE,R=301,L]
        ##RewriteCond %{HTTPS} !=on
        ##RewriteRule ^/?(.*) https://{{ myURL }}.{{ myDomain }}/$1 [R,L]
        ## Turn off LDAP verify on certs
        #####################
        LDAPVerifyServerCert Off
        ## For alfresco proxying. Mod_proxy causes "Warning: Connection Partially
        ## Encrypted" in Firefox.
        #####################
