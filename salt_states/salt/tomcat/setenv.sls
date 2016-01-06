include:
  - tomcat

{% if grains['JAVA_VERSION'] == 8 %}

set_CATALINA_OPTS:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_CATALINA_OPTS Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_CATALINA_OPTS Generated Automatically DO NOT EDIT!!###"
    - require:
      - sls: tomcat
    - content: |
        export CATALINA_OPTS="-Dfile.encoding=UTF-8 \
        -Dcatalina.logbase=/var/log/tomcat7 \
        -Dnet.sf.ehcache.skipUpdateCheck=true \
        -XX:+DoEscapeAnalysis \
        -XX:+UseConcMarkSweepGC \
        -XX:+CMSClassUnloadingEnabled \
        -XX:+UseParNewGC \
        -Djava.net.preferIPv4Stack=true"

{% if grains['node_type'] == 'allinone' %}

set_java_mem:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - content: |
        export CATALINA_OPTS="$CATALINA_OPTS -Xms512m -Xmx24576m"
    - require:
      - sls: tomcat

{% elif grains['node_type'] == 'build' %}

set_java_mem:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - require:
      - sls: tomcat
    - content: export CATALINA_OPTS="$CATALINA_OPTS -Xms512m -Xmx4096m"
      
{% endif %} 


{% elif grains ['JAVA_VERSION'] == 7 %}

set_CATALINA_OPTS:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_CATALINA_OPTS Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_CATALINA_OPTS Generated Automatically DO NOT EDIT!!###"
    - require:
      - sls: tomcat
    - content: |
        export CATALINA_OPTS="-Dfile.encoding=UTF-8 \
        -Dcatalina.logbase=/var/log/tomcat7 \
        -Dnet.sf.ehcache.skipUpdateCheck=true \
        -XX:+DoEscapeAnalysis \
        -XX:+UseConcMarkSweepGC \
        -XX:+CMSClassUnloadingEnabled \
        -XX:+UseParNewGC \
        -Djava.net.preferIPv4Stack=true"

{% if grains['node_type'] == 'allinone' %}

set_java_mem:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - require:
      - sls: tomcat
    - content: export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=2048m -Xms24576m -Xmx24576m"
      
{% elif grains['node_type'] == 'build' %}

set_java_mem:
  file.blockreplace:
    - name: {{ pillar['tomcat_home'] }}/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - require:
      - sls: tomcat
    - content: export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=2048m -Xms6144m -Xmx6144m"
{% endif %}  

{% endif %}
