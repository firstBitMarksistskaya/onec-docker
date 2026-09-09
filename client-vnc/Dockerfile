ARG DOCKER_REGISTRY_URL
ARG ONEC_VERSION=8.3.27.2130
FROM ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}onec-client:${ONEC_VERSION} AS base

FROM debian:bookworm-slim
ARG ONEC_VERSION
ENV PATH="${PATH}:/opt/1cv8/current"
COPY --from=base /opt /opt

# RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/

RUN apt-get update \
  && apt-mark hold iptables \
  && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dbus-x11 \
    psmisc \
    xdg-utils \
    x11-xserver-utils \
    x11-utils \
    xvfb \
    xz-utils \
  && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
  && sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg \
  && echo "deb http://http.debian.net/debian/ bookworm main contrib non-free" > /etc/apt/sources.list \
  # && echo "deb http://http.debian.net/debian/ bookworm-backports main" >> /etc/apt/sources.list \
  && echo "deb http://http.debian.net/debian/ bookworm-proposed-updates main contrib non-free" >> /etc/apt/sources.list \
  && echo "deb http://security.debian.org/debian-security/ bookworm-security main contrib non-free" >> /etc/apt/sources.list \
  && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      locales \
      ttf-mscorefonts-installer \
      libfontconfig1 \
      libgsf-1-114 \
      libglib2.0-0 \
      libgtk2.0-0 \
      libodbc1 \
      libtcmalloc-minimal4 \
      libmagickwand-6.q16-6 \
      libwebkit2gtk-4.0-37 \
      at-spi2-core \
      procps \
      x11vnc \
      iproute2 \
      libglu1-mesa \
  # Install libpng12-0 from xenial
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 40976EAF437D05B5 \
  && echo "deb http://security.ubuntu.com/ubuntu xenial-security main" > /etc/apt/sources.list.d/xenial-security.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libpng12-0 \
  && rm -rf  /etc/apt/sources.list.d/xenial-security.list \
  && apt-get update \
  # Install libwebkitgtk from stretch
  && echo "deb http://archive.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/stretch.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libwebkitgtk-3.0-0 \
  && rm -rf  /etc/apt/sources.list.d/stretch.list \
  && apt-get update \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG=ru_RU.UTF-8

# remove DST Root CA X3 cert if it exists
COPY ./scripts/remove-dst-root-ca-x3.sh /remove-dst-root-ca-x3.sh
RUN chmod +x /remove-dst-root-ca-x3.sh \
  && /remove-dst-root-ca-x3.sh \
  && rm /remove-dst-root-ca-x3.sh

RUN tar xzfh /tmp/s6-overlay-amd64.tar.gz -C / \
  && rm -rf /tmp/s6-overlay-amd64.tar.gz

RUN groupadd -r usr1cv8 --gid=2001 \
  && useradd -r -g usr1cv8 --uid=2001 --home-dir=/home/usr1cv8 --shell=/sbin/nologin usr1cv8 \
  && mkdir -p /home/usr1cv8/.1cv8 \
  && mkdir -p /home/usr1cv8/.1C/1cestart \
  && chown -R usr1cv8:usr1cv8 /home/usr1cv8

COPY ./configs/client-vnc/rootfs/ /

RUN chmod +x /etc/services.d/*/run

ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1440
ENV DISPLAY_HEIGHT=900

EXPOSE 5900

ENTRYPOINT ["/init"]
