#!/bin/bash
set -e

docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_USERNAME

if [ $DOCKER_SYSTEM_PRUNE = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ $NO_CACHE = 'true' ] ; then
	last_arg='--no-cache .'
fi

edt_version=$EDT_VERSION
edt_escaped="${edt_version// /_}"

docker build \
    --pull \
    --build-arg JDK_VERSION=$JDK_VERSION \
    -t $DOCKER_USERNAME/liberica-jdk-full:$JDK_VERSION \
    -f jdk/liberica-full.Dockerfile \
    $last_arg

docker push $DOCKER_USERNAME/liberica-jdk-full:$JDK_VERSION

docker build \
    --pull \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg EDT_VERSION=$EDT_VERSION \
    --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
    --build-arg BASE_IMAGE="liberica-jdk-full" \
    --build-arg BASE_TAG="11" \
    -t $DOCKER_USERNAME/edt:$edt_escaped \
    -f edt/Dockerfile \
    $last_arg

# тут для каждого плагина просто наследуем предыдущий
docker build \
    --build-arg EDT_VERSION=$EDT_VERSION \
    --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
    --build-arg BASE_IMAGE="edt" \
    --build-arg REPOSITORY_URL='https://marmyshev.gitlab.io/edt-editing/update/' \
    --build-arg PACKAGE_NAMES='org.mard.dt.editing.feature.feature.group' \
    -t $DOCKER_USERNAME/edt-editing-plugin:$edt_escaped \
    -f edt/edt-plugins.Dockerfile \
    $last_arg

docker build \
    --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
    --build-arg BASE_IMAGE=edt-editing-plugin \
    --build-arg BASE_TAG=$edt_escaped \
    -t $DOCKER_USERNAME/edt-agent:$edt_escaped \
	-f jenkins-agent/Dockerfile \
    $last_arg

docker push $DOCKER_USERNAME/edt-agent:$edt_escaped
