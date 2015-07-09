#!/bin/bash

SYSLOG_FILE=/etc/rsyslog.conf

if grep -q jplsyslog ${SYSLOG_FILE}; then 
   sed -i 's/notice\@jplsyslog/notice   \@jplsyslog/' ${SYSLOG_FILE};
fi 
