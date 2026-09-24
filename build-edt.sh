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

#Если версия EDT >= 2024.1.0, использовать JDK 17
edt_major_version="${EDT_VERSION%%.*}"
if [[ "$edt_major_version" =~ ^[0-9]+$ ]] && (( edt_major_version >= 2024 )); then
  # Для новых версий используем Ubuntu + Java 17
  # (Это надежнее, чем просто голая Java-платформа)
  BASE_IMAGE="eclipse-temurin"
  BASE_TAG="17-jdk-jammy" 
else
  BASE_IMAGE="eclipse-temurin"
  BASE_TAG="11-jdk-focal"
fi

last_arg='.'
if [ "${NO_CACHE}" = 'true' ] ; then
    last_arg='--no-cache .'
fi

edt_version=$EDT_VERSION
edt_escaped="${edt_version// /_}"

docker build \
    --pull \
    --build-arg DOCKER_REGISTRY_URL=library \
    --build-arg BASE_IMAGE=ubuntu \
    --build-arg BASE_TAG=20.04 \
    --build-arg ONESCRIPT_PACKAGES="yard" \
    -t ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}oscript-downloader:latest \
    -f oscript/Dockerfile \
    $last_arg

docker build \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg EDT_VERSION="$EDT_VERSION" \
    --build-arg BASE_IMAGE=$BASE_IMAGE \
    --build-arg BASE_TAG=$BASE_TAG \
    --build-arg DOWNLOADER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg DOWNLOADER_IMAGE=oscript-downloader \
    --build-arg DOWNLOADER_TAG=latest \
    -t ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}edt:$edt_escaped \
    -f edt/Dockerfile \
    $last_arg
