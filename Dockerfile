FROM ubuntu:xenial

MAINTAINER Kristian Peters <kpeters@ipb-halle.de>

LABEL Description="MetFrag is a tool for in-silico fragmentation for computer assisted identification of metabolite mass spectra."

# Add cran R backport
RUN apt-get -y update
RUN apt-get -y install apt-transport-https
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
#RUN echo "deb https://mirrors.ebi.ac.uk/CRAN/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list

# Update & upgrade sources
RUN apt-get -y update
RUN apt-get -y dist-upgrade

# Install packages
RUN apt-get -y install r-base netcdf-bin libnetcdf-dev libdigest-sha-perl git wget

# Install development files needed
RUN apt-get -y install git maven openjdk-8-jdk openjdk-8-jre tomcat7

# Clean up
RUN apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/{cache,log}/ /tmp/* /var/tmp/*

# Empty tomcat
RUN rm -rf /var/lib/tomcat7/webapps/*

# Fetch MetFrag
WORKDIR /usr/src
RUN git clone --depth 1 https://github.com/ipb-halle/MetFragRelaunched

# Build MetFrag
WORKDIR /usr/src/MetFragRelaunched
RUN mvn clean install -pl MetFragLib -am -DskipTests
RUN mvn package -pl MetFragWeb

# Tomcat needs write permissions
RUN mkdir /tmp/tomcat7
RUN chown -R tomcat7:tomcat7 /tmp/tomcat7
RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7
RUN chown -R tomcat7:tomcat7 /usr/share/tomcat7/

# Add start.sh. WAR Filename (and hence web path!) can be changed through environment Variable
ENV WEBPREFIX=MetFragK8S
ADD metfrag-start.sh /start.sh

# Add file databases 
WORKDIR /
RUN wget -O- https://msbi.ipb-halle.de/~sneumann/file_databases.tgz | tar xzf - 

## Collect additional files
WORKDIR /vol/file_databases
# HMDB4.0 MetFrag Local CSV
RUN wget https://zenodo.org/record/3375500/files/HMDB4_23Aug19.csv
RUN wget https://zenodo.org/record/3403530/files/WormJam_10Sept19.csv
RUN wget https://zenodo.org/record/3434579/files/YMDB2_17Sept2019.csv
RUN wget https://zenodo.org/record/3541624/files/Zebrafish_13Nov2019_Beta.csv
RUN wget https://zenodo.org/record/3472781/files/CompTox_07March19_WWMetaData.csv
RUN wget https://zenodo.org/record/3520106/files/NPAtlas_Aug2019.csv
RUN wget https://zenodo.org/record/3548461/files/NORMANSusDat_20Nov2019.csv
RUN wget https://zenodo.org/record/3547718/files/COCONUT4MetFrag.csv
RUN wget https://zenodo.org/record/3548654/files/PubChemLite_18Nov2019_tier0.csv
RUN wget https://zenodo.org/record/3548654/files/PubChemLite_18Nov2019_tier1.csv
RUN wget https://zenodo.org/record/3564602/files/BloodExposomeDB_03Dec2019.csv

## Raise -Xmx for tomcat against java.lang.OutOfMemoryError: Java heap space
RUN sed -i 's/^JAVA_OPTS="-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC"/JAVA_OPTS="-Djava.awt.headless=true -Xmx512m -XX:+UseConcMarkSweepGC"/' /etc/default/tomcat7

# Run as user tomcat7
USER tomcat7

# Expose port to outside
EXPOSE 8080

# Define Entry point script
ENTRYPOINT ["/bin/sh","/start.sh"]

