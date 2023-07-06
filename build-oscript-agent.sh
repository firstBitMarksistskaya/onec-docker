#!/bin/bash
set -e

if [ $DOCKER_CR_YANDEX = 'true' ] ; then
   cat $DOCKER_PASSWORD | docker login \
      --username $DOCKER_LOGIN \
      --password-stdin \
      cr.yandex
else
   docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_USERNAME
fi

if [ $DOCKER_SYSTEM_PRUNE = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ $NO_CACHE = 'true' ] ; then
	last_arg='--no-cache .'
fi

docker build \
	--pull \
    $no_cache_arg \
	--build-arg DOCKER_USERNAME=library \
    --build-arg BASE_IMAGE=adoptopenjdk \
    --build-arg BASE_TAG=14-hotspot \
    -t $DOCKER_USERNAME/oscript-jdk:latest \
	-f oscript/Dockerfile \
    $last_arg

docker build \
    $no_cache_arg \
	--build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
    --build-arg BASE_IMAGE=oscript-jdk \
    --build-arg BASE_TAG=latest \
    -t $DOCKER_USERNAME/oscript-agent:latest \
	-f jenkins-agent/Dockerfile \
    $last_arg

docker push $DOCKER_USERNAME/oscript-agent:latest
