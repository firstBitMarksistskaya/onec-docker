@echo off

docker login -u %DOCKER_LOGIN% -p %DOCKER_PASSWORD% %DOCKER_REGISTRY_URL%

if %ERRORLEVEL% neq 0 goto end

if %DOCKER_SYSTEM_PRUNE%=="true" docker system prune -af

if %ERRORLEVEL% neq 0 goto end

if %NO_CACHE%=="true" (SET last_arg="--no-cache .") else (SET last_arg=".")

docker build ^
    --pull ^
    --build-arg DOCKER_REGISTRY_URL=library ^
    --build-arg BASE_IMAGE=eclipse-temurin ^
    --build-arg BASE_TAG=17 ^
    -t %DOCKER_REGISTRY_URL%/oscript-jdk:latest ^
    -f oscript/Dockerfile ^
    %last_arg%

if %ERRORLEVEL% neq 0 goto end

docker build ^
    --build-arg DOCKER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
    --build-arg BASE_IMAGE=oscript-jdk ^
    --build-arg BASE_TAG=latest ^
    -t %DOCKER_REGISTRY_URL%/base-jenkins-agent:latest ^
    -f swarm-jenkins-agent/Dockerfile ^
    %last_arg%

if %ERRORLEVEL% neq 0 goto end

docker push %DOCKER_REGISTRY_URL%/base-jenkins-agent:latest

if %ERRORLEVEL% neq 0 goto end

:end
echo End of program.
