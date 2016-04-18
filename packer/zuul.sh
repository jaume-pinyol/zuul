#!/bin/bash

set -e

sudo yum clean all
sleep 1

sudo yum -y update
sleep 1

sudo yum -y install nc rsyslog unzip chkconfig vim wget sysstat git
sleep 1

#For security reasons update usermode https://alas.aws.amazon.com/ALAS-2015-572.html
sudo yum update -y usermode

# Config sysctl parameters
sudo chmod 644 /etc/sysctl.conf
sudo chown root:root /etc/sysctl.conf

# Install AWS tools
sudo yum -y install aws-amitools-ec2.noarch
sleep 1
sudo yum -y install wget aws-cli.noarch
sleep 1

# Install Zuul
sudo yum remove -y java-1.7.0-openjdk
sleep 1
cd /tmp
echo "Installing Java8"

JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jre-8u66-linux-x64.rpm"
#wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" $JAVA_URL
curl -L -b "oraclelicense=a" $JAVA_URL -O
echo "Installing Java8"
sudo yum install -y jre-8u66-linux-x64.rpm
sleep 1

sudo yum -y install tomcat7
sleep 1

#Configure zuul
sudo chown root:root /opt/zuul.war
sudo chmod 644 /opt/zuul.war
sudo cp /opt/zuul.war /var/lib/tomcat7/webapps/ROOT.war
sudo chown tomcat:root /var/lib/tomcat7/webapps/ROOT.war
sudo chown -R tomcat:tomcat /opt/zuul
sleep 1

#
sudo chkconfig tomcat7 on
sudo chkconfig --level 345 tomcat7 on
sleep 1
