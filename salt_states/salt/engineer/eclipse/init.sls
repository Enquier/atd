{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - npm.nodeclipse

extract_eclipse_luna:
  archive:
    - extracted
    - name: /opt/local
    - source: http://mirrors.xmission.com/eclipse/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz
    - archive_format: tar
    - if_missing: /opt/local/eclipse
    - source_hash: md5=44a8a5ae5e74da7b3764da774a505632

add_eclipse_to_path:
  alternatives.install:
    - name: eclipse
    - link: /usr/bin/eclipse
    - path: /opt/local/eclipse/eclipse
    - priority: 50

