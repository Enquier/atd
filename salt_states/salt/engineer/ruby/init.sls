{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_ruby_and_gems:
  pkg.installed:
    - names:
      - ruby
      - rubygems
