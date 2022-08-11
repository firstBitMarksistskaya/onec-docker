eval $(cat .onec.env)

docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_USERNAME

docker build --build-arg DOCKER_USERNAME=$DOCKER_USERNAME \
  --build-arg ONESCRIPT_VERSION=$ONESCRIPT_VERSION \
  -t $DOCKER_USERNAME/oscript:$ONESCRIPT_VERSION \
  -f oscript/Dockerfile .

docker push $DOCKER_USERNAME/oscript:$ONESCRIPT_VERSION
