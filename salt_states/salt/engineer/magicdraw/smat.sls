{#
Installs packaged MagicDraw and adds SMAT plugins
#}

magicdraw_smat_client:
  archive:
    - extracted
    - name: /opt/local/magicdraw/smat
    - source: salt://installer_magicdraw/{{ pillar['magicdraw_smat_version'] }}.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}/bin

extract_smat_europa_timeline:
  archive:
    - extracted
    - name: /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}
    - source: salt://installer_magicdraw/MD17.0.5-Europa-Timeline-v.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}/plugins/Timeline\ Editor\ Plugin/

extract_smat_europa_req:
  archive:
    - extracted
    - name: /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}
    - source: salt://installer_magicdraw/MD17.0.5-JPL-Europa-Reqs-v.zip
    - archive_format: zip
    - if_missing: /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}/plugins/gov.nasa.jpl.europa.requirements

set_smat_magicdraw_to_use_local_config:
  cmd.run:
    - cwd: /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}/bin
    - name: sed -i "s/-DLOCALCONFIG\\\=false/-DLOCALCONFIG\\\=true/g" magicdraw*.properties

create_smat_alias_magicdraw_sh:
  cmd.run:
    - cwd: /etc/profile.d
    - name: echo "alias magicdraw-smat='cd /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}/bin/; ./magicdraw'" > magicdraw-smat.sh

create_smat_alias_magicdraw_csh:
  cmd.run:
    - cwd: /etc/profile.d
    - name: echo "alias magicdraw-smat='cd /opt/local/magicdraw/smat/{{ pillar['magicdraw_smat_version'] }}/bin/; ./magicdraw'" > magicdraw-smat.csh

