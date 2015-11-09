{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{% if grains['os'] == 'Amazon' %}
{% set rhel = 6 %}
{% elseif grains['os'] == 'CentOS' %}
{% set rhel = grains['osmajorrelease'] %}
{% endif %}

epel_repo_install:
  pkgrepo.managed:
    - humanname: Extra Packages for Enterprise Linux {{ rhel }} - $basearch
    - mirrorlist: https://mirrors.fedoraproject.org/metalink?repo=epel-{{ rhel }}&arch=$basearch 
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-{{ rhel }}
    - comments:
        - '#repo installed with salt'

/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-{{ rhel }}:
  file.managed:
    - source: salt://utils/files/RPM-GPG-KEY-EPEL-{{ rhel }}.default
    - user: root
    - group: root