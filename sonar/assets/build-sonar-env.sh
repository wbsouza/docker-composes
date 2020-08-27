#!/bin/sh

set -a
source ../.env

echo "Building \"sonar.properties\" via envsubst"
envsubst < sonar.properties.tmpl > "./sonar.properties"

