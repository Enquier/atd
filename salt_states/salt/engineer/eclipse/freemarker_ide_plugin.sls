{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - eclipse

install_freemarkerIDE_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://download.jboss.org/jbosstools/updates/development/luna -installIUs org.jboss.ide.eclipse.freemarker.feature.feature.group -followReferences"
    - onlyif: test ! -e /opt/local/eclipse/plugins/org.jboss.ide.eclipse.freemarker_1.3.100.Final-v20130717-0627-B14
 
