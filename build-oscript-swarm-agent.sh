#!/usr/bin/env bash
set -eo pipefail

if [ -n "${DOCKER_LOGIN}" ] && [ -n "${DOCKER_PASSWORD}" ] && [ -n "${DOCKER_REGISTRY_URL}" ]; then
    if ! docker login -u "${DOCKER_LOGIN}" -p "${DOCKER_PASSWORD}" "${DOCKER_REGISTRY_URL}"; then
        echo "Docker login failed"
        exit 1
    fi
else
    echo "Skipping Docker login due to missing credentials"
fi

if [ "${DOCKER_SYSTEM_PRUNE}" = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ "${NO_CACHE}" = 'true' ] ; then
    last_arg='--no-cache .'
fi

docker build \
    --pull \
    $no_cache_arg \
    --build-arg DOCKER_REGISTRY_URL=library \
    --build-arg BASE_IMAGE=eclipse-temurin \
    --build-arg BASE_TAG=17 \
    -t ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}oscript-jdk:latest \
    -f oscript/Dockerfile \
    $last_arg

docker build \
    $no_cache_arg \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg BASE_IMAGE=oscript-jdk \
    --build-arg BASE_TAG=latest \
    -t ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}oscript-agent:latest \
    -f swarm-jenkins-agent/Dockerfile \
    $last_arg

if [[ -n "$DOCKER_REGISTRY_URL" ]]; then
  docker push $DOCKER_REGISTRY_URL/oscript-agent:latest
else
  echo "DOCKER_REGISTRY_URL not set, skipping docker push."
fi
