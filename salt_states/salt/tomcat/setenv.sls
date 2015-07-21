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
        -XX:+UseParNewGC \
        -Xms512m -Xmx16384m"


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
        -XX:+UseParNewGC \
        -XX:MaxPermSize=2048m -Xms32768m -Xmx32768m"





{% endif %}