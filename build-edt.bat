@echo off

if "%DOCKER_LOGIN%%DOCKER_PASSWORD%" neq "" (
  docker login -u %DOCKER_LOGIN% -p %DOCKER_PASSWORD% %DOCKER_REGISTRY_URL%
) else (
  echo Skipping Docker login due to missing credentials
)

if %ERRORLEVEL% neq 0 goto end

if "%DOCKER_SYSTEM_PRUNE%"=="true" docker system prune -af

if %ERRORLEVEL% neq 0 goto end

for /f "delims=." %%a in ("%EDT_VERSION%") do set EDT_MAJOR_VERSION=%%a
if %EDT_MAJOR_VERSION% GEQ 2024 (
  set BASE_IMAGE="azul/zulu-openjdk"
  set BASE_TAG="17"
) else (
  set BASE_IMAGE="eclipse-temurin"
  set BASE_TAG="11"
)

if %ERRORLEVEL% neq 0 goto end

if "%NO_CACHE%"=="true" (SET "last_arg=--no-cache .") else (SET "last_arg=.")

set edt_version=%EDT_VERSION%
set edt_escaped=%edt_version: =_%

docker build ^
    --pull ^
    --build-arg DOCKER_REGISTRY_URL=library ^
    --build-arg BASE_IMAGE=ubuntu ^
    --build-arg BASE_TAG=20.04 ^
    --build-arg ONESCRIPT_PACKAGES="yard" ^
    -t %DOCKER_REGISTRY_URL%/oscript-downloader:latest ^
    -f oscript/Dockerfile ^
    %last_arg%

docker build ^
    --build-arg ONEC_USERNAME=%ONEC_USERNAME% ^
    --build-arg ONEC_PASSWORD=%ONEC_PASSWORD% ^
    --build-arg EDT_VERSION=%EDT_VERSION% ^
    --build-arg BASE_IMAGE=%BASE_IMAGE% ^
    --build-arg BASE_TAG=%BASE_TAG% ^
    --build-arg DOWNLOADER_REGISTRY_URL=%DOCKER_REGISTRY_URL% ^
    --build-arg DOWNLOADER_IMAGE=oscript-downloader ^
    --build-arg DOWNLOADER_TAG=latest ^
    -t %DOCKER_REGISTRY_URL%/edt:%edt_escaped% ^
    -f edt/Dockerfile ^
    %last_arg%

if %ERRORLEVEL% neq 0 goto end

:end
echo End of program.
