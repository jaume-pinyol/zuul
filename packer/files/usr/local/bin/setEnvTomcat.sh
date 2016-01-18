#!/bin/bash

totalMemSize () {
  MEM=$(cat /proc/meminfo  | awk '/MemTotal: / { print int($2 / 1024) }')
  echo $MEM
}

heapSizeCalc () {
  MEM=$(totalMemSize)
  P50=$(expr $MEM / 2)
  FIXED=$(expr $MEM - 1024)
  if [ $MEM -ge 10240 ]; then
    FIXED=$(expr $MEM - 5120)
  fi
  P90=$(expr $MEM \* 9 / 10)
  RETVAL=1024
  if [ $FIXED -gt $P90 ]; then
    RETVAL=$P90
  else
    if [ $FIXED -gt $P50 ]; then
      RETVAL=$FIXED
    fi
  fi
  echo $RETVAL
}

javaOptsHeapSizeCalc () {
  BUF=$1
  MEM=$(totalMemSize)
  SIZE=$(heapSizeCalc)
  JAVA_MAX_MEMORY=$(expr $SIZE - $MEM \* $BUF / 100)
  echo "-Xms${JAVA_MAX_MEMORY}m -Xmx${JAVA_MAX_MEMORY}m"
}

GCLOG=/var/log/tomcat/gc.log
JMX_PORT=9012

export JAVA_OPTS=""
export JAVA_ARGS=" \
    -XX:PermSize=128m -XX:MaxPermSize=128m \
    $(javaOptsHeapSizeCalc 0) \
    -Xloggc:$GCLOG \
    -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M \
    -verbosegc -verbose:sizes \
    -XX:-PrintGC -XX:-PrintGCDetails \
    -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution \
    -XX:-TraceClassUnloading -XX:-TraceClassLoading \
    -XX:+HeapDumpOnOutOfMemoryError \
    -Dcom.sun.management.jmxremote.port=$JMX_PORT \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -Dcom.sun.management.jmxremote.ssl=false"
    #-XX:+UseG1GC
    #-XX:+DisableExplicitGC \
    #-XX:ParallelGCThreads=2 -XX:+UseConcMarkSweepGC \
    #-XX:-UseGCOverheadLimit \
    #-XX:+CMSScavengeBeforeRemark -XX:+CMSParallelRemarkEnabled \
    #-XX:+ExplicitGCInvokesConcurrent \
echo $JAVA_ARGS
