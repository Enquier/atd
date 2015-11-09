{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{% set majver = grains['osmajorrelease'] %}



epel_repo_install:
  pkgrepo.managed:
    - humanname: Extra Packages for Enterprise Linux {{ majver }} - $basearch
    - mirrorlist: https://mirrors.fedoraproject.org/metalink?repo=epel-{{ majver }}&arch=$basearch 
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-{{ majver }}
    - comments:
        - '#repo installed with salt'

/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-{{ majver }}:
  file.managed:
    - source: salt://utils/files/RPM-GPG-KEY-EPEL-{{ majver }}.default
    - user: root
    - group: root