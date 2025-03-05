ARG DOCKER_REGISTRY_URL=library
ARG BASE_IMAGE=debian
ARG BASE_TAG=bullseye-slim

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

# Install OpenJDK
ARG OPENJDK_VERSION=17

ADD https://packages.adoptium.net/artifactory/api/gpg/key/public /etc/apt/keyrings/adoptium.asc
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    dirmngr \
    git \
    gnupg \
    locales \
    software-properties-common \
    wget \
  && mkdir -p /etc/apt/keyrings \
  && echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
  && apt update \
  && apt install -y temurin-${OPENJDK_VERSION}-jdk \
  && rm -rf  \
  /var/lib/apt/lists/* \
  /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# remove DST Root CA X3 cert if it exists
COPY ./scripts/remove-dst-root-ca-x3.sh /remove-dst-root-ca-x3.sh
RUN chmod +x /remove-dst-root-ca-x3.sh \
  && /remove-dst-root-ca-x3.sh \
  && rm /remove-dst-root-ca-x3.sh

ENV LANG=ru_RU.UTF-8
