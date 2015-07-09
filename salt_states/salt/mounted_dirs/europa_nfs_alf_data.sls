{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - mounted_dirs

{% set hostname = grains['id'] %}
{% set environment = grains['node_env'] %}

{% if grains['node_type'] == "alfresco" or grains['node_type'] == "allinone" %}

mount_alf_data_nfs:
  file.append:
    - name: /etc/fstab
    - text: europa-nfs:/export_alfresco         /mnt/{{ environment }}_alf_data_nfs nfs4     rw,nosuid,dev,exec,auto,nouser,sync,fsc 0 0

/mnt/{{ environment }}_alf_data_nfs:
  file.directory:
  - user: tomcat
  - group: tomcat

run_mount_dirs:
  cmd.run:
  - name: mount -a

{% endif %}
