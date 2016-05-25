#!/bin/sh

kubectl delete service metfrag-service
kubectl delete rc metfrag-rc

docker rm -f $(docker ps | grep google_containers | awk '{ print $1 }')

