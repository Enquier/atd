{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

include:
  - eclipse

install_pydev_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    #- name: "nci install from http://pydev.sf.net/updates/ org.python.pydev"
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://pydev.sf.net/updates/ -installIUs org.python.pydev.feature.feature.group -followReferences"
    - onlyif: test ! -e /opt/local/eclipse/plugins/org.python.pydev.core_3.6.0.201406232321
 
