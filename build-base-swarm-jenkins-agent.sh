#!/bin/bash
set -e

docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_REGISTRY_URL

if [ $DOCKER_SYSTEM_PRUNE = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ $NO_CACHE = 'true' ] ; then
    last_arg='--no-cache .'
fi

# если устанавливаем Coverage41C, то предварительно нужно собрать образы EDT
if [[ $COVERAGE41C_VERSION != "" ]] ; then
  ./build-edt-swarm-agent.sh
fi

docker build \
	--pull \
    $no_cache_arg \
	--build-arg DOCKER_REGISTRY_URL=library \
    --build-arg BASE_IMAGE=ubuntu \
    --build-arg BASE_TAG=20.04 \
    --build-arg ONESCRIPT_PACKAGES="yard" \
    -t $DOCKER_REGISTRY_URL/oscript-downloader:latest \
	-f oscript/Dockerfile \
    $last_arg

docker build \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg BASE_IMAGE=oscript-downloader \
    --build-arg BASE_TAG=latest \
    -t $DOCKER_REGISTRY_URL/onec-client:$ONEC_VERSION \
    -f client/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/onec-client:$ONEC_VERSION

docker build \
    --pull \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    -t $DOCKER_REGISTRY_URL/onec-client-vnc:$ONEC_VERSION \
    -f client-vnc/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/onec-client-vnc:$ONEC_VERSION

docker build \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg BASE_IMAGE=onec-client-vnc \
    --build-arg BASE_TAG=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/onec-client-vnc-oscript:$ONEC_VERSION \
    -f oscript/Dockerfile \
    $last_arg

docker build \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg BASE_IMAGE=onec-client-vnc-oscript \
    --build-arg BASE_TAG=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/onec-client-vnc-oscript-jdk:$ONEC_VERSION \
    -f jdk/Dockerfile \
    $last_arg

docker build \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg BASE_IMAGE=onec-client-vnc-oscript-jdk \
    --build-arg BASE_TAG=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/onec-client-vnc-oscript-jdk-testutils:$ONEC_VERSION \
    -f test-utils/Dockerfile \
    $last_arg

docker build \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg BASE_IMAGE=onec-client-vnc-oscript-jdk-testutils \
    --build-arg BASE_TAG=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/base-jenkins-agent:$ONEC_VERSION \
    -f swarm-jenkins-agent/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/base-jenkins-agent:$ONEC_VERSION

if [[ $COVERAGE41C_VERSION != "" ]] ; then
    docker build \
       --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
       --build-arg BASE_IMAGE=base-jenkins-agent \
       --build-arg BASE_TAG=$ONEC_VERSION \
       --build-arg EDT_VERSION=$EDT_VERSION \
       --build-arg COVERAGE41C_VERSION=$COVERAGE41C_VERSION \
       -t $DOCKER_REGISTRY_URL/base-jenkins-coverage-agent:$ONEC_VERSION \
       -f coverage41C/Dockerfile \
       $last_arg

    docker push $DOCKER_REGISTRY_URL/base-jenkins-coverage-agent:$ONEC_VERSION
fi
