ARG DOCKER_USERNAME=library
ARG BASE_IMAGE=adoptopenjdk
ARG BASE_TAG=14-hotspot

FROM ${DOCKER_USERNAME}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG EDT_VERSION=2021.3.4

ENV installer_type=edt \
  ONEC_VERSION=${EDT_VERSION}

COPY ./scripts/download_og.sh /download_og.sh


WORKDIR /tmp

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    # downloader dependencies
    curl \
    # edt dependencies
    libgtk-3-0 \
    locales \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/* \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ARG downloads=downloads/developmenttools10/${ONEC_VERSION}
ENV LANG ru_RU.UTF-8

# Install EDT
COPY ./distr ./${downloads}
RUN rm ./${downloads}/.gitkeep \
  && rm -rf ${downloads}/server*.tar.gz \
  && rm -rf ${downloads}/deb*.tar.gz \
  && rm -rf ${downloads}/thin.client*.tar.gz \
  && if [ -z "$(ls -A ${downloads})" ]; then \
  chmod +x /download_og.sh \
  && sync; /download_og.sh; \
  fi \
  && ls ${downloads} \
  && for file in ${downloads}/*.tar.gz; do tar -zxf "$file"; done \
  && rm -rf ${downloads}/*.tar.gz \
  && ./1ce-installer-cli install all --ignore-hardware-checks \
  && rm -rf /tmp/* \
  && mv $(dirname $(find /opt/1C/1CE -name ring)) /opt/1C/1CE/components/1c-enterprise-ring

ENV PATH="/opt/1C/1CE/components/1c-enterprise-ring:$PATH"
