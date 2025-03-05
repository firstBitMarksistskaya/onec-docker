# Используем базовый образ для скачивания
ARG DOCKER_REGISTRY_URL=localhost:5000
ARG BASE_IMAGE=oscript-downloader
ARG BASE_TAG=latest
FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG} AS downloader

# Копирование скрипта скачивания и локальных дистрибутивов
COPY ./scripts/download_yard.sh /download.sh
COPY ./distr /distr
RUN chmod +x /download.sh

# Скачивание дистрибутива 1С с использованием вынесенного скрипта
ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION

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

RUN /download.sh "$ONEC_USERNAME" "$ONEC_PASSWORD" "$ONEC_VERSION" "client"

# Начало основной стадии сборки
FROM ubuntu:20.04 AS installedonec

# Копируем скрипты и файлы установки
ARG ONEC_VERSION
ARG gosu_ver=1.11
ARG nls_enabled=false
ENV nls=$nls_enabled
ENV distrPath=/tmp/downloads/Platform83/${ONEC_VERSION}
ENV installer_type=client

RUN set -xe \
  && chmod 777 -R /tmp \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    libwebkit2gtk-4.0-37

COPY ./scripts/install_new.sh /install.sh
COPY --from=downloader /tmp/ /tmp/
WORKDIR ${distrPath}      

SHELL ["/bin/bash", "-c"]
RUN ls . \
  && chmod +x /install.sh \
  && sync; /install.sh

# create symlink to current 1c:enterprise directory
COPY ./scripts/create-symlink-to-current-1cv8.sh /create-symlink-to-current-1cv8.sh
RUN chmod +x /create-symlink-to-current-1cv8.sh \
  && /create-symlink-to-current-1cv8.sh \
  && rm /create-symlink-to-current-1cv8.sh

COPY ./configs/client/current/ /opt/1cv8/current/

FROM ubuntu:20.04
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

ARG onec_uid="999"
ARG onec_gid="999"

COPY --from=installedonec /opt /opt

# RUN set -xe \
#   && chmod 777 -R /tmp \
#   && apt-get update \
#   && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
#   && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
#     ca-certificates \
#     dbus-x11 \
#     libfontconfig1 \
#     libglib2.0-0 \
#     libgsf-1-114 \
#     libgtk2.0-0 \
#     libodbc1 \
#     libsm6 \
#     libwebkit2gtk-4.0-37 \
#     locales \
#     ttf-mscorefonts-installer \
#     xvfb \
#   && rm -rf  \
#     /var/lib/apt/lists/* \
#     /var/cache/debconf \
#   && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
#   && Xvfb :1 -screen 0 1024x768x24 &

RUN set -xe \
  && chmod 777 -R /tmp \
  && apt-get update \
  && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
  && DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    ca-certificates \
    dbus-x11 \
    libfontconfig1 \
    libglib2.0-0 \
    libgsf-1-114 \
    libgtk2.0-0 \
    libodbc1 \
    libsm6 \
    libwebkit2gtk-4.0-37 \
    locales \
    ttf-mscorefonts-installer \
    xvfb \
  && rm -rf /var/lib/apt/lists/* /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ENV LANG=ru_RU.UTF-8

RUN groupadd -r grp1cv8 --gid=$onec_gid \
  && useradd -r -g grp1cv8 --uid=$onec_uid --home-dir=/home/usr1cv8 --shell=/bin/bash usr1cv8 \
  && mkdir -p /home/usr1cv8/.1cv8 \
  && chown -R usr1cv8:grp1cv8 /home/usr1cv8

VOLUME /home/usr1cv8/.1cv8/

COPY ./client/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh / \
  && chmod +x /usr/local/bin/docker-entrypoint.sh \
  && mkdir -p /tmp/.X11-unix \
  && chmod 1777 -R /tmp

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

USER usr1cv8

CMD ["1cv8"]
