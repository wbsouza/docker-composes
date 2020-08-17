#!/bin/sh

set -a
source ../.env

echo "Building \"gitlab.rb\" via envsubst"
envsubst < gitlab.rb.tmpl > "./gitlab.rb"


