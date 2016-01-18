#!/bin/bash
echo "JAVA_OPTS=\"\$JAVA_OPTS $(/usr/local/bin/tomcat-init.sh)\"" >> /etc/tomcat7/tomcat7.conf
