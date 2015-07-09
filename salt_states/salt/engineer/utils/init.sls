{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_misc_utils:
  pkg.installed:
    - names:
      - curl
      - cabextract
      - xorg-x11-font-utils
      - fontconfig
      - coreutils
