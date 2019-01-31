#!/bin/sh

# Environment variables needed by catalina.sh
export CATALINA_HOME="/usr/share/tomcat7"
export CATALINA_BASE="/var/lib/tomcat7"
export CATALINA_PID="/var/run/tomcat7.pid"
export CATALINA_SH="${CATALINA_HOME}/bin/catalina.sh"
export CATALINA_TMPDIR="/tmp/tomcat7"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export JAVA_OPTS="-Djava.awt.headless=true -Xms2048m -Xmx4096m -XX:PermSize=1024m -XX:MaxPermSize=3072m"
export JSSE_HOME="${JAVA_HOME}/jre/lib/jsse.jar"

# Workdir
cd /usr/src/MetFragRelaunched

# Inject settings.properties
cd /usr/src/MetFragRelaunched/MetFragWeb/src/main/webapp/
#cp /usr/src/MetFragRelaunched/MetFragWeb/target/MetFragWeb.war /var/lib/tomcat7/webapps/ROOT.war
#jar uvf /var/lib/tomcat7/webapps/ROOT.war resources/settings.properties

cp /usr/src/MetFragRelaunched/MetFragWeb/target/MetFragWeb.war /var/lib/tomcat7/webapps/MetFragK8S.war

cd /var/lib/tomcat7/webapps/
mkdir MetFragK8S
chown tomcat7 MetFragK8S
cd MetFragK8S
jar uvf /usr/src/MetFragRelaunched/MetFragWeb/target/MetFragWeb.war resources/settings.properties

# Start tomcat
$CATALINA_SH run
