include:
  - tomcat
  - tomcat.setenv
  - tomcat.apache_apr

copy_server_file:
  file.managed:
    - name: {{ pillar['tomcat_home'] }}/conf/server.xml
    - source: salt://tomcat/files/server.xml
    - template: jinja
    - user: root
    - group: root
    - mode: 644

configure_http_connector:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/conf/server.xml
    - marker_start: "<!--START :: SALT :: configure_http_connector DO NOT EDIT MANUALLY -->"
    - marker_end: "<!--END :: SALT :: configure_http_connector DO NOT EDIT MANUALLY -->"
    - content: <Connector port="{{ pillar['tomcat_http'] }}" URIEncoding="UTF-8" protocol="HTTP/1.1"  redirectPort="{{ pillar['tomcat_ssl'] }}" />
    - require:
      - file: copy_server_file
      
configure_ajp_connector:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/conf/server.xml
    - marker_start: "<!--START :: SALT :: configure_ajp_connector DO NOT EDIT MANUALLY -->"
    - marker_end: "<!--END :: SALT :: configure_ajp_connector DO NOT EDIT MANUALLY -->"
    - content: <Connector port="{{ pillar['tomcat_ajp'] }}" URIEncoding="UTF-8" protocol="AJP/1.3"  redirectPort="{{ pillar['tomcat_ssl'] }}" />
    - require:
      - file: copy_server_file
      
configure_ssl_connector:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/conf/server.xml
    - require:
      - file: copy_server_file
    - marker_start: "<!--START :: SALT :: configure_ssl_connector DO NOT EDIT MANUALLY -->"
    - marker_end: "<!--END :: SALT :: configure_ssl_connector DO NOT EDIT MANUALLY -->"
    - content: |
        <Connector port="{{ pillar['tomcat_ssl'] }}" URIEncoding="UTF-8" protocol="HTTP/1.1" SSLEnabled="true"
                SSLCertificateFile="/etc/pki/certs/{{ pillar['ssl_cert_name'] }}.crt"
                SSLCertificateKeyFile="/etc/pki/certs/server.key"
                SSLCertificateChainFile="/etc/pki/certs/{{ pillar['ssl_bundle_name'] }}.crt"
                SSLVerifyClient="optional" SSLProtocol="all"
        />