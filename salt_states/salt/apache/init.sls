{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
copy_certs:
  file.recurse:
    - name: /etc/pki/certs
    - source: salt://apache/files/certs/{{ pillar['ssl_cert_dir'] }}

apache:
 pkg.installed:
   - pkgs:
     - httpd
     - mod_ssl
     - mod_ldap
 service:
  - name: httpd
  - running
  - enable: True
  - reload: True
  - watch:
    - pkg: apache
    - file: /etc/httpd/conf/httpd.conf
    - file: /etc/httpd/conf.d/ssl.conf
    - file: /etc/httpd/worker.properties

/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://apache/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

/etc/httpd/conf.d/ssl.conf:
  file.managed:
    - source: salt://apache/files/conf.d/ssl.conf
    - user: root
    - group: root
    - mode: 644

update_ssl_certificate_name:
  file.blockreplace:
    - name: /etc/httpd/conf.d/ssl.conf
    - marker_start: '## START :: SALT :: ssl_cert_name settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: ssl_cert_name settings. Do not edit Manually'
    - content: SSLCertificateFile /etc/pki/certs/{{ pillar['ssl_cert_name'] }}.crt

update_ssl_bundle_name:
  file.blockreplace:
    - name: /etc/httpd/conf.d/ssl.conf
    - marker_start: '## START :: SALT :: ssl_bundle_name settings. Do not edit Manually'
    - marker_end: '## END :: SALT :: ssl_bundle_name settings. Do not edit Manually'
    - content: SSLCertificateChainFile /etc/pki/certs/{{ pillar['ssl_bundle_name'] }}.crt   

/etc/httpd/workers.properties:
  file.managed:
    - source: salt://apache/files/workers.properties
    - user: root
    - group: root
    - mode: 644

disable_server_signature:
  module.run:
    - name: file.replace
    - path: /etc/httpd/conf/httpd.conf
    - pattern: ServerSignature.*$
    - repl: ServerSignature Off

disable_product_information:
  module.run:
    - name: file.replace
    - path: /etc/httpd/conf/httpd.conf
    - pattern: ServerTokens.*$
    - repl: ServerTokens Prod
