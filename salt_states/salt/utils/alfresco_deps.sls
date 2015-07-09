{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
 - utils

alfresco_deps:
  pkg.installed:
    - names:
      - ImageMagick
      - ImageMagick-devel
      - giflib-devel
      - libpng-devel
      - ghostscript-devel
      - gcc-c++
      - libreoffice
      - libreoffice-headless 
