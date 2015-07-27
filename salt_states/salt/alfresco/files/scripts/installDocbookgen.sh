#!/bin/bash
cd /opt/local
docbookgenZip=`ls -t {{ pillar['tomcat_home'] }}/amps/docbookgen*.tgz | head -1`
tar -cvfz {{ pillar['tomcat_home'] }}/amps/$docbookgenZip
sudo chown -R tomcat:jpl docbookgen
exit 0