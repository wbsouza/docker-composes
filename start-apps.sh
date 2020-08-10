#!/bin/sh

DOCKER=/usr/bin/docker
DOCKER_COMPOSE=/usr/local/bin/docker-compose

WEB_NETWORK=$($DOCKER network ls | grep web)
if [ "${WEB_NETWORK}" == "" ]; then
  $DOCKER network create web
fi

(cd traefik; $DOCKER_COMPOSE up -d)
(cd sonar; $DOCKER_COMPOSE up -d)
(cd gitlab; $DOCKER_COMPOSE up -d)
(cd plantuml; $DOCKER_COMPOSE up -d)

NET_DEVICE=$(ip route | grep default | grep -v tun | awk '{ print $5 }' | sed -z 's/\n//')
HOST_IP=$(ip route| grep $NET_DEVICE | grep -v default | grep src | awk '{ print $9 }' | sed -z 's/\n//')

TRAEFIK_IP=$(docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" traefik)
if [ "${TRAEFIK_IP}" == "" ]; then
  TRAEFIK_IP=$(docker inspect --format "{{ .NetworkSettings.IPAddress }}" traefik)
fi

if [ "${TRAEFIK_IP}" != "" ]; then
  echo "Exposing the Traefik ports (80, 443) to the external world..."
  iptables -I FORWARD 1 -s $HOST_IP -d $TRAEFIK_IP -p tcp --dport 80 -j ACCEPT
  iptables -I FORWARD 1 -s $HOST_IP -d $TRAEFIK_IP -p tcp --dport 443 -j ACCEPT
  iptables -A FORWARD -d $TRAEFIK_IP -p tcp --dport 80 -j DROP
  iptables -A FORWARD -d $TRAEFIK_IP -p tcp --dport 443 -j DROP
else
  echo ">>> Error trying to get the traefik IP address"
fi

