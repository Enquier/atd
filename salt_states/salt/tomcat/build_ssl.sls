include:
  - tomcat
  - tomcat.setenv
  - tomcat.apache_apr

/opt/local/apache-tomcat/conf/server.xml:
  file.managed:
    - source: salt://tomcat/files/server_build.xml
    - user: root
    - group: root
    - mode: 644
    
    
configure_ssl_connector:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/conf/server.xml
    - marker_start: "<!--START :: SALT :: configure_ssl_connector DO NOT EDIT MANUALLY -->"
    - marker_end: "<!--END :: SALT :: configure_ssl_connector DO NOT EDIT MANUALLY -->"
    - content: |
        <Connector port="8443" URIEncoding="UTF-8" protocol="HTTP/1.1" SSLEnabled="true"
                SSLCertificateFile="/etc/pki/certs/{{ pillar['ssl_cert_name'] }}.crt"
                SSLCertificateKeyFile="/etc/pki/certs/server.key"
                SSLCertificateChainFile="/etc/pki/certs/{{ pillar['ssl_bundle_name'] }}.crt"
                SSLVerifyClient="optional" SSLProtocol="all"
        />