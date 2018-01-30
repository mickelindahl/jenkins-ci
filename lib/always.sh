#!/usr/bin/env bash

IMAGES=$(docker images -f 'dangling=true' -q --no-trunc);
IMAGES=$(echo $IMAGES | tr '\n' ' ')

if [ ! -d "$IMAGES" ]; then

    docker rmi ${IMAGES};

fi
