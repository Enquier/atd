{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{# EPEL has x2go. This is not necessary. Commented out. SW 11/7/2014
   Also removed package "x2gognomebindings" that Ian had installed from x2go repo. Epel
   does not have this package. Doesn't seem to be necessary so removed it.

x2goRepo:
  pkgrepo.managed:
    - humanname: x2go (replaces NX) (RHEL_6)
    - baseurl: http://download.opensuse.org/repositories/X11:/RemoteDesktop:/x2go/RHEL_6
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: http://download.opensuse.org/repositories/X11:/RemoteDesktop:/x2go/RHEL_6/repodata/repomd.xml.key
    - comments:
        - '#repo installed with salt'
#}

xserver:
  pkg.installed:
    - names:
      - x2goserver
      - x2goserver-xsession
