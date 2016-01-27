FROM ubuntu

MAINTAINER Kristian Peters <kpeters@ipb-halle.de>

LABEL Description="Install MetFrag in Docker."

# add cran R backport
RUN apt-get -y install apt-transport-https
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN echo "deb https://cran.uni-muenster.de/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list

# update & upgrade sources
RUN apt-get -y update
RUN apt-get -y dist-upgrade

# install packages
RUN apt-get -y install r-base netcdf-bin libnetcdf-dev libdigest-sha-perl wget

# install development files needed
RUN apt-get -y install git maven openjdk-7-jdk openjdk-7-jre

# clean up
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# install MetFrag
WORKDIR /usr/src
RUN wget -O MetFrag.tgz http://msbi.ipb-halle.de/~cruttkie/92f73acb731145c73ffa3dfb8fd59581bee0d844963889338c3ec173874b5a5f/MetFrag.tgz
RUN tar -xzf MetFrag.tgz

WORKDIR /usr/src/MetFrag
RUN mvn clean install -pl MetFragLib -am -DskipTests
RUN echo "cd /usr/src/MetFrag; mvn clean -Dcontainer=tomcat7 tomcat:run-war -pl MetFragWeb -am -DskipTests" > /usr/src/MetFrag/start.sh; chmod +x /usr/src/MetFrag/start.sh

# Expose port to outside
EXPOSE 8080

# Define Entry point script
ENTRYPOINT ["/bin/sh","/usr/src/MetFrag/start.sh"]

