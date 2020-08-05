#!/bin/sh

docker network create web

docker-compose -f traefik/docker-compose.yml up -d
docker-compose -f sonar/docker-compose.yml up -d
docker-compose -f gitlab/docker-compose.yml up -d

