#!/bin/bash

SYSLOG_FILE=/etc/rsyslog.conf

if grep -q jplsyslog ${SYSLOG_FILE}; then 
   exit 1; 
else 
   sed -i '/begin forwarding rule/i \
# Log to JPLIT security syslog server:\
kern.emerg;auth.info;authpriv.info;daemon.notice   @jplsyslog.jpl.nasa.gov\
' ${SYSLOG_FILE}; 
fi 
