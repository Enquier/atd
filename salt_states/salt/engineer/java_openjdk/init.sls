{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_openjdk:
  pkg.installed:
    - names: 
      - java-1.7.0-openjdk-devel
      - java-1.6.0-openjdk-devel
