{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

install_python_pip:
  pkg.installed:
    - names:
      - python-pip 
