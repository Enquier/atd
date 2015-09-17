{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
epel_repo_install:
  pkgrepo.managed:
    - humanname: Extra Packages for Enterprise Linux 7 - $basearch
    - mirrorlist: https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch 
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
    - comments:
        - '#repo installed with salt'

/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7:
  file.managed:
    - source: salt://utils/files/RPM-GPG-KEY-EPEL-7.default
    - user: root
    - group: root
 
