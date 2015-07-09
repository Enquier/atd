{#
Installs packaged MagicDraw and adds SMAT plugins
#}

magicdraw_alt_client:
  archive:
    - extracted
    - name: /opt/local/magicdraw/alt
    - source: salt://installer_magicdraw/{{ pillar['magicdraw_alt_version'] }}.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/bin

extract_alt_europa_timeline:
  archive:
    - extracted
    - name: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}
    - source: salt://installer_magicdraw/MD17.0.5-Europa-Timeline-v.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/plugins/Timeline\ Editor\ Plugin/

extract_alt_europa_req:
  archive:
    - extracted
    - name: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}
    - source: salt://installer_magicdraw/MD17.0.5-JPL-Europa-Reqs-v.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/plugins/gov.nasa.jpl.europa.requirements

extract_alt_caesar:
  archive:
    - extracted
    - name: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}
    - source: salt://installer_magicdraw/CAESAR_Plugin.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/plugins/gov.nasa.jpl.caesar

set_alt_magicdraw_to_use_local_config:
  cmd.run:
    - cwd: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/bin
    - name: sed -i "s/-DLOCALCONFIG\\\=false/-DLOCALCONFIG\\\=true/g" magicdraw*.properties

set_alt_magicdraw_java:
  cmd.run:
    - cwd: /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/bin
    - name: sed -i "s/JAVA_HOME=/JAVA_HOME=\/etc\/alternatives\/java_sdk_1.7.0/g" magicdraw*.properties

create_alt_alias_magicdraw_sh:
  cmd.run:
    - cwd: /etc/profile.d
    - name: echo "alias magicdraw-alt='cd /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/bin/; ./magicdraw'" > magicdraw-alt.sh

create_alt_alias_magicdraw_csh:
  cmd.run:
    - cwd: /etc/profile.d
    - name: echo "alias magicdraw-alt='cd /opt/local/magicdraw/alt/{{ pillar['magicdraw_alt_version'] }}/bin/; ./magicdraw'" > magicdraw-alt.csh

