ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE
ARG BASE_TAG

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

RUN set -xe \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      curl \
      git \
      locales \
      openssh-client \
      wget \
  # git-lfs
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git-lfs \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ENV LANG=ru_RU.UTF-8

COPY ./swarm-jenkins-agent/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
