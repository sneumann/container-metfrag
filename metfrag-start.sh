#!/bin/sh

# Environment variables needed by catalina.sh
export CATALINA_HOME="/usr/share/tomcat7"
export CATALINA_BASE="/var/lib/tomcat7"
export CATALINA_PID="/var/run/tomcat7.pid"
export CATALINA_SH="${CATALINA_HOME}/bin/catalina.sh"
export CATALINA_TMPDIR="/tmp/tomcat7"
export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
export JAVA_OPTS="-Djava.awt.headless=true -Xmx128M"
export JSSE_HOME="${JAVA_HOME}/jre/lib/jsse.jar"

# Workdir
cd /usr/src/MetFragRelaunched

# Inject settings.properties
cd /usr/src/MetFragRelaunched/MetFragWeb/src/main/webapp/
cp /usr/src/MetFragRelaunched/MetFragWeb/target/MetFragWeb.war /var/lib/tomcat7/webapps/ROOT.war
jar uvf /var/lib/tomcat7/webapps/ROOT.war resources/settings.properties

# Start tomcat
$CATALINA_SH run
