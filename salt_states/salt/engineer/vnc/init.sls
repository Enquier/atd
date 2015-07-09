{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_vnc:
  pkg.installed:
    - names:
      - tigervnc
      - tigervnc-server
      - xorg-x11-fonts-Type1
