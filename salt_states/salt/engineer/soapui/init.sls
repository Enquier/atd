{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}

download_soapinstaller:
  file.managed:
    - name: /tmp/soap_ui.sh
    - source: salt://installer_soapui/soap_ui.sh

download_soapui_install_config:
  file.managed:
    - name: /tmp/soapui-response.varfile
    - source: salt://soapui/files/response.varfile.default

install_soapui:
  cmd.run:
    - name: sh /tmp/soap_ui.sh -q -varfile /tmp/soapui-response.varfile
    - onlyif: test ! -e /opt/local/SmartBear/{{ pillar['soapui_version'] }}/{{ pillar['soapui_version'] }}.desktop

add_soapui_to_path:
  alternatives.install:
    - name: soapui
    - link: /usr/bin/soapui
    - path: /opt/local/SmartBear/{{ pillar['soapui_version'] }}/bin/soapui.sh
    - priority: 30
