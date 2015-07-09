{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_office_tools:
  pkg.installed:
    - names:
      - libreoffice-base
      - libreoffice-core
      - libreoffice-calc
      - libreoffice-writer
      - libreoffice-math
      - libreoffice-impress
