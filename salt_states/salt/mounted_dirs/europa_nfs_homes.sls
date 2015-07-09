{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include:
  - mounted_dirs

{% set imageID = grains['server_image_id'] %}
{% set cloud_type = "undefined" %}

{% if imageID is undefined %}
 {% set imageID = "undefuned" %}

{% elif 'ami' in imageID %}
  {% set cloud_type = "amazon" %}

 {% else %}
   {% set cloud_type = "nebula" %}
{% endif %}

{% if cloud_type == "amazon"  %}

mount_home_dirs:
  file.append:
   - name: /etc/fstab
   - text: europa-nfs:/export          /home   nfs4     rw,nosuid,dev,exec,auto,nouser,sync,fsc 0 0 

mount_dirs:
  cmd.run:
  - name: mount -a

{% endif %}

