{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

/tmp/oxygen-64bit.sh:
  file.managed:
    - source: salt://installer_oxygen/oxygen-64bit.sh
    - onlyif: test ! -e /tmp/oxygen-64bit.sh
    - user: root
    - group: root
    - mode: 755

/tmp/oxygenxml-response.varfile:
  file.managed:
    - source: salt://oxygenxml/files/response.varfile.default

oxygen_install:
 cmd.run:
  - name: /tmp/oxygen-64bit.sh -q -varfile /tmp/oxygenxml-response.varfile
  - onlyif: test ! -e /opt/local/oxygen_xml/install.properties

/etc/skel/.com.oxygenxml/:
  file.directory:
  - user: root
  - group: root
  - makedirs: True

/etc/skel/.com.oxygenxml/license.xml:
  file.managed:
    - source: salt://oxygenxml/files/license_server.xml.default

add_to_path:
  alternatives.install:
    - name: oxygen
    - link: /usr/bin/oxygen
    - path: /opt/local/oxygen_xml/oxygen.sh
    - priority: 30
