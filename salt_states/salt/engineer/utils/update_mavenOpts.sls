{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

update_maven_options:
  file.append:
    - name: /etc/profile
    - text:
      - "## SALT MANAGED: Set maven opts for jrebel jar in eclipse"
      - "export MAVEN_OPTS='-Xms256m -Xmx1G -XX:PermSize=300m -Xdebug -Xrunjdwp:transport=dt_socket,address=10000,server=y,suspend=n -javaagent:/opt/eclipse/plugins/org.zeroturnaround.eclipse.embedder_5.5.1.RELEASE-201402211559/jrebel/jrebel.jar'" 
