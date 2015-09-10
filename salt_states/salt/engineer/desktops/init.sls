{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

default_gnome:
  module.run:
    - name: pkg.group_install
    - m_name: "GNOME Desktop"
