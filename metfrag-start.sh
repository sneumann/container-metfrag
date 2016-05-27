#!/bin/sh

#USER tomcat7
#GROUP tomcat7

# Environment variables needed by catalina.sh
export CATALINA_HOME="/usr/share/tomcat7"
export CATALINA_BASE="/var/lib/tomcat7"
export CATALINA_PID="/var/run/tomcat7.pid"
export CATALINA_SH="${CATALINA_HOME}/bin/catalina.sh"
export CATALINA_TMPDIR="/tmp/tomcat7-tmp"
export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
export JAVA_OPTS="-Djava.awt.headless=true -Xmx128M"
export JSSE_HOME="${JAVA_HOME}/jre/lib/jsse.jar"

# Workdir
cd /usr/src/MetFragRelaunched

# Load tomcat manually
#mvn tomcat7:run-war-only -pl MetFragWeb

# Use tomcat7 from ubuntu
mvn package -pl MetFragWeb
cp -r MetFragWeb/target/MetFragWeb.war /var/lib/tomcat7/webapps/MetFragWeb.war

$CATALINA_SH run

