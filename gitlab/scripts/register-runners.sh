#!/bin/sh
# Get the registration token from:
# http://localhost:${GITLAB_HTTP_PORT}/root/${project}/settings/ci_cd 

if [ "$#" -ne 1 ]; then
  echo "Usage $0 \$GITLAB_REGISTRATION_TOKEN"
else

  REGISTRATION_TOKEN=$1
  source ../.env

  echo "Registering runners with the registration_token=${REGISTRATION_TOKEN} ..."

  for RUNNER in runner1 runner2 runner3
  do
    docker exec -it $RUNNER gitlab-runner register \
      --non-interactive \
      --registration-token "${REGISTRATION_TOKEN}" \
      --locked=false \
      --description docker-stable \
      --url "http://gitlab:${GITLAB_HTTP_PORT}" \
      --executor docker \
      --docker-image docker:stable \
      --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
      --docker-network-mode web
  done
fi



