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

{% elif grains['JAVA_VERSION'] == 'Oracle8' %}

java_8_jdk:
  cmd.run:
    - cwd: /opt/src/
    - name:  |
        wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         "http://download.oracle.com/otn-pub/java/jdk/8u51-b16/server-jre-8u51-linux-x64.tar.gz"
    - user: root
    - group: root

java_8_unpack:
  archive.extracted:
    - name: /opt/local/
    - source: /opt/src/server-jre-8u51-linux.tar.gz
    - archive_format: tar
    - tar_options: z
    - if_missing: /usr/bin/java
    
java_8_alternatives1:
  cmd.run:
    - name: |
        alternatives --install /usr/bin/java java /opt/local/jdk1.8.0_51/bin/java 1
    - user: root
    - group: root
    - require: 
      - file: /opt/local/jdk_1.8.0_51
     
java_8_alternatives2:
  cmd.run:
    - name: |
        alternatives --install /usr/bin/java java /opt/local/jdk1.8.0_51/bin/java 1
    - user: root
    - group: root
    - require: 
      - file: /opt/local/jdk_1.8.0_51
          
     
{% endif %}

java_env_vars:
  file.append:
    - name: /etc/profile.d/java.sh
    - text:
      - JAVA_HOME=/usr/lib/jvm/java
      - JRE_HOME=/usr/lib/jvm/jre
      - export JAVA_HOME JRE_HOME

