{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014

Scala plugin requires a bunch of stuff.. need to find the right easy way to install all in one shot
#}

include:
  - eclipse

install_scala_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://download.scala-ide.org/sdk/helium/e38/scala210/stable/site -installIUs org.scala-ide.sdt.feature.feature.group -installIUs org.scala-ide.sdt.weaving.feature.feature.group -followReferences"
    - onlyif: test ! -e org.scala-ide.sdt.core_3.0.3.v-2_10-201403271605-8d2c756.jar
 
