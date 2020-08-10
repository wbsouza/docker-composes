#!/bin/sh

/scripts/wait-for.sh gitlab:${GITLAB_HTTP_PORT} -t 1200
/entrypoint

