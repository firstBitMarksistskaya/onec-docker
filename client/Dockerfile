FROM alpine:latest as downloader

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ENV installer_type=client

COPY ./scripts/download.sh /download.sh

WORKDIR /tmp

RUN apk --no-cache add bash curl grep \
  && chmod +x /download.sh \
  && sync; /download.sh \
  && for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *.tar.gz \
  && rm ./*-thin-*.deb

FROM ubuntu:18.04 as base

ARG nls_enabled=false
ENV nls=$nls_enabled

COPY --from=downloader /tmp/*.deb /tmp/

RUN set -xe \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libwebkitgtk-3.0-0

WORKDIR /tmp

SHELL ["/bin/bash", "-c"]
RUN set -xe; \
  if [ "$nls" = true ]; then \
    dpkg -i 1c-enterprise*-{common,server}_*.deb; \
    dpkg -i 1c-enterprise*-{common,client}*.deb; \
  else \
    dpkg -i 1c-enterprise*-{common,server,client}_*.deb; \
  fi

# create symlink to current 1c:enterprise directory
COPY ./scripts/create-symlink-to-current-1cv8.sh /create-symlink-to-current-1cv8.sh
RUN chmod +x /create-symlink-to-current-1cv8.sh \
  && /create-symlink-to-current-1cv8.sh \
  && rm /create-symlink-to-current-1cv8.sh

COPY ./configs/client/current/ /opt/1cv8/current/

FROM ubuntu:18.04
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

ARG onec_uid="999"
ARG onec_gid="999"

COPY --from=base /opt /opt

RUN set -xe \
  && apt-get update \
  && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      locales \
      ca-certificates \
      libgtk2.0-0 \
      libwebkitgtk-3.0-0 \
      ttf-mscorefonts-installer \
      libfontconfig1 \
      libgsf-1-114 \
      libglib2.0-0 \
      libodbc1 \
      libmagickwand-6.q16-3 \
      dbus-x11 \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.UTF-8

RUN groupadd -r grp1cv8 --gid=$onec_gid \
  && useradd -r -g grp1cv8 --uid=$onec_uid --home-dir=/home/usr1cv8 --shell=/bin/bash usr1cv8 \
  && mkdir -p /home/usr1cv8/.1cv8 \
  && chown -R usr1cv8:grp1cv8 /home/usr1cv8

VOLUME /home/usr1cv8/.1cv8/

USER usr1cv8

CMD ["/opt/1C/v8.3/x86_64/1cv8"]
