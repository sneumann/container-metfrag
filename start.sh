#!/bin/sh

# Make sure to add the following entry in /etc/default/grub:
#GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"

# docker daemon --storage-driver=overlay
docker info
docker pull ubuntu

# building:
docker build -t docker-metfrag .
docker run --publish=8890:8080 --log-driver=syslog --name docker-metfrag-run -i -t -d docker-metfrag

# manually:
#docker run -P -i -t --name=docker-metfrag ubuntu /bin/bash
#docker ps -a
#docker commit docker-metfrag
#docker rmi docker-metfrag

