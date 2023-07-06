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
    --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_USERNAME/crs:$ONEC_VERSION \
    -f crs/Dockerfile \
    $last_arg

docker push $DOCKER_USERNAME/crs:$ONEC_VERSION

docker build \
    --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_USERNAME/crs-apache:$ONEC_VERSION \
    -f crs-apache/Dockerfile \
    $last_arg

docker push $DOCKER_USERNAME/crs-apache:$ONEC_VERSION
