{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014

JIRA plugin 
#}

include:
  - eclipse

install_atlassian_plugin_from_market:
  cmd.run:
    - cwd: /opt/local/eclipse/
    - name: "eclipse -application org.eclipse.equinox.p2.director -noSplash -repository http://update.atlassian.com/atlassian-eclipse-plugin/rest/e3.7 -installIUs com.atlassian.connector.eclipse.jira.feature.group -followReferences"
    - onlyif: test ! -e com.atlassian.connector.eclipse.jira.core_3.0.8.v20130328.jar 
