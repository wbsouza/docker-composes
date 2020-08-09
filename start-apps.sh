#!/bin/sh

WEB_NETWORK=$(docker network ls | grep web)
if [ "${WEB_NETWORK}" == "" ]; then
  docker network create web
fi

(cd traefik; docker-compose up -d)
(cd sonar; docker-compose up -d)
(cd gitlab; docker-compose up -d)
(cd plantuml; docker-compose up -d)

