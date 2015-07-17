/opt/jfrog/artifactory/tomcat/conf/server.xml:
  file.managed:
    - source: salt://tomcat/files/server_artifactory.xml
    - user: root
    - group: root
    - mode: 644
    
    
configure_ssl_connector:
  file.blockreplace:
    - name: /opt/jfrog/artifactory/tomcat/conf/server.xml
    - marker_start: "<!--START :: SALT :: configure_ssl_connector DO NOT EDIT MANUALLY -->"
    - marker_end: "<!--END :: SALT :: configure_ssl_connector DO NOT EDIT MANUALLY -->"
    - content: |
        <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
                SSLCertificateFile="/etc/pki/tls/certs/{{ pillar['ssl_cert_name'] }}.crt"
                SSLCertificateKeyFile="/etc/pki/tls/private/server.key"
                SSLCertificateChainFile="/etc/pki/tls/certs/{{ pillar['ssl_bundle_name'] }}.crt"
                SSLVerifyClient="optional" SSLProtocol="all"
        />