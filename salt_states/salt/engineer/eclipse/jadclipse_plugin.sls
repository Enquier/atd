{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - eclipse

install_jadclipse_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://feeling.sourceforge.net/update -installIUs org.sf.feeling.decompiler.feature.group -followReferences"
    - onlyif: test ! -e /opt/local/eclipse/plugins/org.sf.feeling.decompiler_1.0.3.201211040213.jar
 
