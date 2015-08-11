{% set  md_ver = grains['MAGICDRAW_VERSION'] %}

teamwork_zip_unpack:
  archive.extracted:
    - name: /usr/src/teamwork
    - source: salt://teamwork/files/MagicDraw_{{ md_ver }}_teamwork_server_no_install.zip
    - archive_format: zip
    - onlyif: test ! -e /opt/local/teamwork/bin/teamwork_server.properties
    
{#
teamwork_deploy:
  file.directory

set_java_home:
  file.blockreplace:
    - name: /opt/local/teamwork/
#START::SALT::TEAMWORK set_java_home Created Automatically by SALT DO NOT EDIT!!
JAVA_HOME=
#END::SALT::TEAMWORK set_java_home Created Automatically by SALT DO NOT EDIT!!

#}