ARG DOCKER_USERNAME=library
ARG BASE_IMAGE=debian
ARG BASE_TAG=bullseye-slim

FROM ${DOCKER_USERNAME}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

# Install OpenJDK
ARG OPENJDK_VERSION=15

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      git \
      gnupg \
      dirmngr \
      locales \
      software-properties-common \
      wget \
  && wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public -O adoptopenjdk.gpg.public \
  && gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import adoptopenjdk.gpg.public \
  && gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg \
  && rm adoptopenjdk-keyring.gpg adoptopenjdk.gpg.public \
  && mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings \
  && chown root:root /usr/share/keyrings/adoptopenjdk-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb bullseye main" | tee /etc/apt/sources.list.d/adoptopenjdk.list \
  && apt-get update \
  # see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199#23
  && mkdir -p /usr/share/man/man1 \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      adoptopenjdk-${OPENJDK_VERSION}-hotspot \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# remove DST Root CA X3 cert if it exists
COPY ./scripts/remove-dst-root-ca-x3.sh /remove-dst-root-ca-x3.sh
RUN chmod +x /remove-dst-root-ca-x3.sh \
  && /remove-dst-root-ca-x3.sh \
  && rm /remove-dst-root-ca-x3.sh

ENV LANG ru_RU.UTF-8
