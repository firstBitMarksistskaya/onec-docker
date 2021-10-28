FROM alpine:latest as downloader

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ENV installer_type=server32

COPY ./scripts/download.sh /download.sh

WORKDIR /tmp

RUN apk --no-cache add bash curl grep \
  && chmod +x /download.sh \
  && sync; /download.sh \
  && for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *.tar.gz

FROM i386/debian:bullseye-slim as base

ARG gosu_ver=1.11
ARG nls_enabled=false
ENV nls=$nls_enabled

COPY --from=downloader /tmp/*.deb /tmp/

WORKDIR /tmp

SHELL ["/bin/bash", "-c"]
RUN set -xe; \
  if [ "$nls" = true ]; then \
    dpkg -i 1c-enterprise*-{common,server,ws,crs}*.deb; \
  else \
    dpkg -i 1c-enterprise*-{common,server,ws,crs}_*.deb; \
  fi

# create symlink to current 1c:enterprise directory
COPY ./scripts/create-symlink-to-current-1cv8.sh /create-symlink-to-current-1cv8.sh
RUN chmod +x /create-symlink-to-current-1cv8.sh \
  && /create-symlink-to-current-1cv8.sh \
  && rm /create-symlink-to-current-1cv8.sh

ADD https://github.com/tianon/gosu/releases/download/$gosu_ver/gosu-i386 /bin/gosu

RUN chmod +x /bin/gosu

FROM i386/debian:bullseye-slim
LABEL maintainer="Anton Kvashenkin <anton.jugatsu@gmail.com> (@jugatsu)"

ARG onec_uid="999"
ARG onec_gid="999"

COPY --from=base /opt /opt
COPY --from=base /bin/gosu /bin/gosu

RUN set -xe \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      locales \
  && rm -rf \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.UTF-8

RUN groupadd -r grp1cv8 --gid=$onec_gid \
  && useradd -r -g grp1cv8 --uid=$onec_uid --home-dir=/home/usr1cv8 --shell=/bin/bash usr1cv8 \
  && mkdir -p /home/usr1cv8/.1cv8 \
  && chown -R usr1cv8:grp1cv8 /home/usr1cv8

VOLUME /home/usr1cv8/.1cv8

COPY ./crs/docker-entrypoint.sh /usr/local/bin
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 1542
CMD ["crserver"]
