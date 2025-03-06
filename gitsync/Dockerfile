ARG DOCKER_REGISTRY_URL
ARG ONEC_VERSION
FROM ${DOCKER_REGISTRY_URL}/onec-client:${ONEC_VERSION} AS onecclient

FROM mono:5.20-slim
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

ARG gitsync_ver=3.0.0

COPY --from=onecclient /opt /opt

RUN echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/stretch.list \
  && echo "deb http://http.debian.net/debian/ stretch-updates main contrib non-free" >> > /etc/apt/sources.list.d/stretch-updates.list \
  && echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> > /etc/apt/sources.list.d/stretch-security-updates.list \
  && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    dbus-x11 \
    git \
    libfontconfig1 \
    libglib2.0-0 \
    libgsf-1-114 \
    libmagickwand-6.q16-3 \
    libmono-system-runtime-serialization4.0-cil \
    libodbc1 \
    libwebkitgtk-3.0-0 \
    locales \
    ttf-mscorefonts-installer \
  && rm -rf \
    /etc/apt/sources.list.d/stretch.list \
    /etc/apt/sources.list.d/stretch-updates.list \
    /etc/apt/sources.list.d/stretch-security-updates.list \
  && apt-get update \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG=ru_RU.UTF-8

ADD https://github.com/oscript-library/gitsync/releases/download/$gitsync_ver/gitsync.exe /gitsync.exe

ENTRYPOINT ["mono", "gitsync.exe"]
CMD ["usage"]
