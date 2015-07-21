{% if grains['JAVA_VERSION'] == 8 %}

set_java_opts:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_opts Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_opts Generated Automatically DO NOT EDIT!!###"
    - content: |
        export JAVA_OPTS="-Dfile.encoding=UTF-8 \
        -Dcatalina.logbase=/var/log/tomcat7 \
        -Dnet.sf.ehcache.skipUpdateCheck=true \
        -XX:+DoEscapeAnalysis \
        -XX:+UseConcMarkSweepGC \
        -XX:+CMSClassUnloadingEnabled \
        -XX:+UseParNewGC"

{% if grains['node_type'] == 'allinone' %}

set_java_mem:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - content: export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx16384m"

{% elif grains['node_type'] == 'build' %}

set_java_mem:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - content: export JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx4096m"

{% endif %} 


{% elif grains ['JAVA_VERSION'] == 7 %}

set_java_opts:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_opts Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_opts Generated Automatically DO NOT EDIT!!###"
    - content: |
        export JAVA_OPTS="-Dfile.encoding=UTF-8 \
        -Dcatalina.logbase=/var/log/tomcat7 \
        -Dnet.sf.ehcache.skipUpdateCheck=true \
        -XX:+DoEscapeAnalysis \
        -XX:+UseConcMarkSweepGC \
        -XX:+CMSClassUnloadingEnabled \
        -XX:+UseParNewGC"

{% if grains['node_type'] == 'allinone' %}

set_java_mem:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - content: export JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=2048m -Xms32768m -Xmx32768m"

{% elif grains['node_type'] == 'build' %}

set_java_mem:
  file.blockreplace:
    - name: /opt/local/apache-tomcat/bin/setenv.sh
    - marker_start: "### START :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - marker_end: "### END :: SALT :: set_java_mem Generated Automatically DO NOT EDIT!!###"
    - content: export JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=2048m -Xms8192m -Xmx8192m"

{% endif %}  

{% endif %}
