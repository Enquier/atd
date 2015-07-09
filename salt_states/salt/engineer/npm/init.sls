{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_npm_pkgmgr:
  pkg.installed:
    - names: 
      - npm
