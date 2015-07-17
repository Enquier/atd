export JAVA_HOME=`echo $JRE_HOME`
export JAVA_OPTS="-Dfile.encoding=UTF-8 \
  -Dcatalina.logbase=/var/log/tomcat7 \
  -Dnet.sf.ehcache.skipUpdateCheck=true \
  -XX:+DoEscapeAnalysis \
  -XX:+UseConcMarkSweepGC \
  -XX:+CMSClassUnloadingEnabled \
  -XX:+UseParNewGC \
  -XX:MaxPermSize=2048m -Xms32768m -Xmx32768m"
export PATH=$JAVA_HOME/bin:$PATH
TOMCAT_HOME=`echo $TOMCAT_HOME`
