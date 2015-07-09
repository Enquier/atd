#!/bin/bash
cd /opt/local
docbookgenZip=`ls -t /opt/local/apache-tomcat/amps/docbookgen*.tgz | head -1`
tar -cvfz /opt/local/apache-tomcat/amps/$docbookgenZip
sudo chown -R tomcat:jpl docbookgen
exit 0