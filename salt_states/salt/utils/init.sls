{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

sysutils:
  pkg.installed:
    - names:
      - unzip
      - xpdf.x86_64
      - git
      - wget
      - nmap

at:
  pkg.installed:
    - name: at
  service.running:
    - name: atd
    - enable: True