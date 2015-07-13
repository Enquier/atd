{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
install_keepalived:
  pkg.installed:
    - names:
      - keepalived
