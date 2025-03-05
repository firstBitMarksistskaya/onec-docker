# Используем базовый образ для скачивания
ARG DOCKER_REGISTRY_URL=localhost:5000
ARG DOWNLOADER_IMAGE=oscript-downloader
ARG DOWNLOADER_TAG=latest

ARG BASE_IMAGE=eclipse-temurin
ARG BASE_TAG=11

FROM ${DOCKER_REGISTRY_URL}/${DOWNLOADER_IMAGE}:${DOWNLOADER_TAG} AS downloader

# Копирование скрипта скачивания и локальных дистрибутивов
COPY ./scripts/download_yard.sh /download.sh
COPY ./distr /distr
RUN chmod +x /download.sh

# Скачивание дистрибутива 1С с использованием вынесенного скрипта
ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG EDT_VERSION=2021.3

WORKDIR /tmp

# Установка необходимых пакетов и генерация локали
RUN apt-get update \
  && apt-get install --yes \
    locales \
    p7zip-full \
    p7zip-rar \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen ru_RU.UTF-8 \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# Установка переменных окружения для корректной работы локали
ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:ru
ENV LC_ALL=ru_RU.UTF-8

RUN /download.sh "$ONEC_USERNAME" "$ONEC_PASSWORD" "$EDT_VERSION" "edt"


FROM ${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

WORKDIR /tmp

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    curl \
    libgtk-3-0 \
    locales \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/* \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ARG EDT_VERSION=2021.3
ARG downloads=downloads/DevelopmentTools10/${EDT_VERSION}

# Установка переменных окружения для корректной работы локали
ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:ru
ENV LC_ALL=ru_RU.UTF-8

# Install EDT
COPY --from=downloader /tmp/${downloads} /tmp/${downloads}

WORKDIR /tmp/${downloads}

RUN chmod +x ./1ce-installer-cli \
  && ./1ce-installer-cli install all --ignore-hardware-checks --ignore-signature-warnings\
  && rm -rf /tmp/* \
  && mv $(dirname $(find /opt/1C/1CE -name ring)) /opt/1C/1CE/components/1c-enterprise-ring \
  #1cedtcli отсутствует в EDT версии <2023.1.0
  && { if [ -n "$(find /opt/1C/1CE -name 1cedtcli)" ]; then \
      mv $(dirname $(find /opt/1C/1CE -name 1cedtcli)) /opt/1C/1CE/components/1cedtcli; \
    fi }

ENV PATH="/opt/1C/1CE/components/1c-enterprise-ring:/opt/1C/1CE/components/1cedtcli:$PATH"
