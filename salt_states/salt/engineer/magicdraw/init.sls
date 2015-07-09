{#
Installs latest packaged MagicDraw
#}

magicdraw_client:
  archive:
    - extracted
    - name: /opt/local/magicdraw/latest
    - source: salt://installer_magicdraw/{{ pillar['magicdraw_latest_version'] }}.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/latest/{{ pillar['magicdraw_latest_version'] }}

set_magicdraw_to_use_local_config:
  cmd.run:
    - cwd: /opt/local/magicdraw/latest/{{ pillar['magicdraw_latest_version'] }}/bin
    - name: sed -i "s/-DLOCALCONFIG\\\=false/-DLOCALCONFIG\\\=true/g" magicdraw*.properties

set_magicdraw_java:
  cmd.run:
    - cwd: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/bin
    - name: sed -i "s/JAVA_HOME=/JAVA_HOME=\/etc\/alternatives\/java_sdk_1.7.0/g" magicdraw*.properties
  
create_alias_magicdraw_sh:
  cmd.run:
    - cwd: /etc/profile.d
    - name: echo "alias magicdraw='cd /opt/local/magicdraw/latest/{{ pillar['magicdraw_latest_version'] }}/bin/; ./magicdraw'" > magicdraw.sh

create_alias_magicdraw_csh:
  cmd.run:
    - cwd: /etc/profile.d
    - name: echo "alias magicdraw='cd /opt/local/magicdraw/latest/{{ pillar['magicdraw_latest_version'] }}/bin/; ./magicdraw'" > magicdraw.csh
