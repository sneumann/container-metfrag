#!/bin/sh

# Copy local settings file to project
cp /vol/metfragweb/settings.properties .

# Bring up docker containers
docker-compose -f docker-compose.yaml up -d

