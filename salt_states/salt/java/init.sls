{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{% if grains['JAVA_VERSION'] == 8 %}
java_8_jdk_unpack:
  module.run:
    - name: archive.tar
    - options: xf
    - tarfile: /opt/local/jre.gz
    - dest: /opt/local/
    - onlyif: test ! -e /opt/local/jre/bin/java
    - require:
      - file: /opt/local/jre.gz

java_create_sym:
  file.symlink:
    - name: /opt/local/jre
    - target: /opt/local/jdk1.8.0_05
    - require:
      - file: /opt/local/jre.gz

/opt/local/jre.gz:
  file.managed:
    - source: salt://java/files/server-jre-8u5-linux-x64.gz
    - user: root
    - group: root
    - mode: 644

{% elif grains['JAVA_VERSION'] == 7 %}

java_7_jdk_develop:
  pkg.installed:
    - name: java-1.7.0-openjdk-devel.x86_64

{# CYL not sure why we downloaded the JRE gz
java_7_jdk_unpack:
  module.run:
    - name: archive.tar
    - options: xf
    - tarfile: /opt/local/jre.gz
    - dest: /opt/local/
    - onlyif: test ! -e /opt/local/jre/bin/java
    - require:
      - file: /opt/local/jre.gz

java_unlink:
  cmd.run:
    - name: unlink /opt/local/jre

java_create_sym:
  file.symlink:
    - name: /opt/local/jre
    - target: /opt/local/jdk1.7.0_60
    - require:
      - file: /opt/local/jre.gz

/opt/local/jre.gz:
  file.managed:
    - source: salt://java/files/server-jre-7u60-linux-x64.gz
    - user: root
    - group: root
    - mode: 644
#}

{% endif %}

java_env_vars:
  file.append:
    - name: /etc/profile
    - text:
      - JAVA_HOME=/usr
      - JRE_HOME=/usr
      - export JAVA_HOME JRE_HOME

