#!/bin/sh

# Bring up main k8s pods
docker-compose -f k8s.yaml up -d

# Wait a short while until pods are up
sleep 10

# Start replication controller
kubectl create -f k8s_rc.yaml

# Start service
kubectl create -f k8s_service.yaml

