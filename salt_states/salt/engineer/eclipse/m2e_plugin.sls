{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - eclipse

install_m2e_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://download.eclipse.org/technology/m2e/releases -installIUs org.eclipse.m2e.feature.feature.group -followReferences"
 
