#!/usr/bin/env bash

NAME=$1
TAG=$2

IMAGES=$(docker images -f before="${NAME}:${TAG}" -f reference="${NAME}:*" -q --no-trunc)
IMAGES=$(echo $IMAGES | tr '\n' ' ')

if [ "$IMAGES" = "" ]; then

    echo 'success no image to remove'

else

    docker rmi ${IMAGES}

fi
