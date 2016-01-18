#!/bin/bash
eval $(/usr/local/bin/userdata)

# Configure Cassandra hostname
PRIAM_CASSANDRA=priamzuul.images-dev.schibsted.io.
PRIAM_CASSANDRA=cassandra-zuul.$EC2_REGION.$CLOUD_ENVIRONMENT.schibsted.io
JMX_PORT=9012
ZUUL_PROPERTIES_PATH=file:///opt/zuul/zuul.properties
cassHost=$(curl http://$PRIAM_CASSANDRA/Priam/REST/v1/cassconfig/get_seeds -s)
TOMCAT_JAVA_OPTS="-DCASSANDRA_HOSTS=$cassHost"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -DEC2_REGION=$EC2_REGION"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -DCLOUD_EUREKA=$CLOUD_EUREKA"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.deployment.environment=$CLOUD_ENVIRONMENT"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.deployment.region=$EC2_REGION"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.deployment.datacenter=$CLOUD_CLUSTER"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.deployment.applicationId=$CLOUD_APP"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.deployment.serverId="
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.deployment.stack=$CLOUD_STACK"
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Darchaius.configurationSource.additionalUrls=$ZUUL_PROPERTIES_PATH"
#TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Dcom.sun.management.jmxremote"
#TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT"
#TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
#TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
TOMCAT_JVM_ARGS=$(/usr/local/bin/setEnvTomcat.sh)
TOMCAT_JAVA_OPTS="$TOMCAT_JAVA_OPTS $TOMCAT_JVM_ARGS"

echo $TOMCAT_JAVA_OPTS
