{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - eclipse

install_jrebel_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://update.zeroturnaround.com/update-site -installIUs org.zeroturnaround.eclipse.feature.feature.group -followReferences"
    - onlyif: test ! -e /opt/local/eclipse/plugins/org.zeroturnaround.eclipse.config 5.6.0.RELEASE-201406251309
 
