{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

{% if grains['JAVA_VERSION'] == 8 %}


java_8_jdk:
  pkg.latest:
    - name: java-1.8.0-openjdk

java_8_jdk_develop:
  pkg.latest:
    - name: java-1.8.0-openjdk-devel

{% elif grains['JAVA_VERSION'] == 7 %}

java_7_jdk:
  pkg.latest:
    - name: java-1.7.0-openjdk

java_7_jdk_develop:
  pkg.latest:
    - name: java-1.7.0-openjdk-devel



{% endif %}

java_env_vars:
  file.append:
    - name: /etc/profile.d/java.sh
    - text:
      - JAVA_HOME=/usr/lib/jvm/java
      - JRE_HOME=/usr/lib/jvm/jre
      - export JAVA_HOME JRE_HOME

