eval $(cat .onec.env)

docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_USERNAME

if [ $DOCKER_SYSTEM_PRUNE = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ $NO_CACHE = 'true' ] ; then
    last_arg='--no-cache .'
fi

docker build --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
  --build-arg LANGUAGE_PACK=$LANGUAGE_PACK \
  --build-arg ONESCRIPT_VERSION=$ONESCRIPT_VERSION \
  --build-arg BUILD_LANGUAGE=$BUILD_LANGUAGE \
  --build-arg BUILD_LANG=$BUILD_LANG \
  --build-arg BUILD_LC_ALL=$BUILD_LC_ALL \
  --build-arg TAG_PREFIX=$TAG_PREFIX \
  -t $DOCKER_USERNAME/oscript:$TAG_PREFIX$ONESCRIPT_VERSION \
  -f oscript-ru/Dockerfile \
  $last_arg

docker push $DOCKER_USERNAME/oscript:$TAG_PREFIX$ONESCRIPT_VERSION
