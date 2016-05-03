FROM ubuntu

MAINTAINER Kristian Peters <kpeters@ipb-halle.de>

LABEL Description="Install MetFrag in Docker."

# Add cran R backport
RUN apt-get -y install apt-transport-https
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN echo "deb https://cran.uni-muenster.de/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list

# Update & upgrade sources
RUN apt-get -y update
RUN apt-get -y dist-upgrade

# Install packages
RUN apt-get -y install r-base netcdf-bin libnetcdf-dev libdigest-sha-perl git wget

# Install development files needed
RUN apt-get -y install git maven openjdk-7-jdk openjdk-7-jre

# Clean up
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Fetch MetFrag
WORKDIR /usr/src
RUN git clone https://github.com/c-ruttkies/MetFragRelaunched

# Add settings
ADD settings.properties MetFragWeb/src/main/webapp/resources/settings.properties

# Compile MetFrag
WORKDIR /usr/src/MetFragRelaunched
RUN mvn clean install -pl MetFragLib -am -DskipTests
RUN mvn clean -Dcontainer=tomcat7 tomcat:run-war -pl MetFragWeb -am -DskipTests" > /usr/src/MetFragRelaunched/start.sh
RUN chmod +x /usr/src/MetFragRelaunched/start.sh

# Expose port to outside
EXPOSE 8080

# Define Entry point script
ENTRYPOINT ["/bin/sh","/usr/src/MetFragRelaunched/start.sh"]

