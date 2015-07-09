{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - vnc
  - utils

install_msfonts_deps:
  pkg.installed:
    - names:
      - cabextract
      - fontconfig
      - xorg-x11-font-utils

/tmp/msttcore-fonts-installer-2.6-1.noarch.rpm:
  file.managed:
    - source: salt://vnc/files/msttcore-fonts-installer-2.6-1.noarch.rpm
    - onlyif: test ! -e /tmp/msttcore-fonts-installer-2.6-1.noarch.rpm

msfonts_install:
  cmd.run:
    - cwd: /tmp/
    - name: rpm -Uvh /tmp/msttcore-fonts-installer-2.6-1.noarch.rpm
    - onlyif: test ! -e /usr/share/fonts/msttcore/

