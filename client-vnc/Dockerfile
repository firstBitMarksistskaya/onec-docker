ARG DOCKER_USERNAME
ARG ONEC_VERSION
FROM ${DOCKER_USERNAME}/onec-client:${ONEC_VERSION} as base

FROM debian:stretch-slim
ARG ONEC_VERSION
ARG ONEC_8318PLUS_VERSION
ENV onec_ver=$ONEC_VERSION
ENV onec_8318plus_version=$ONEC_8318PLUS_VERSION

COPY --from=base /opt /opt

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
  && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    xfce4 \
  && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gtk3-engines-xfce \
    libgtk-3-bin \
    libpulse0 \
    mousepad \
    xfce4-notifyd \
    xfce4-taskmanager \
    xfce4-terminal \
  && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    xfce4-battery-plugin \
    xfce4-clipman-plugin \
    xfce4-cpufreq-plugin \
    xfce4-cpugraph-plugin \
    xfce4-diskperf-plugin \
    xfce4-datetime-plugin \
    xfce4-fsguard-plugin \
    xfce4-genmon-plugin \
    xfce4-indicator-plugin \
    xfce4-netload-plugin \
    xfce4-notes-plugin \
    xfce4-places-plugin \
    xfce4-sensors-plugin \
    xfce4-smartbookmark-plugin \
    xfce4-systemload-plugin \
    xfce4-timer-plugin \
    xfce4-verve-plugin \
    xfce4-weather-plugin \
    xfce4-whiskermenu-plugin \
  && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxv1 \
    mesa-utils \
    mesa-utils-extra \
  && sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    dirmngr \
    gnupg \
  && echo "deb http://http.debian.net/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
  && echo "deb http://http.debian.net/debian/ stretch-backports main" >> /etc/apt/sources.list \
  && echo "deb http://http.debian.net/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list \
  && echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list \
  && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      locales \
      libwebkitgtk-3.0-0 \
      ttf-mscorefonts-installer \
      libfontconfig1 \
      libgsf-1-114 \
      libglib2.0-0 \
      libodbc1 \
      libtcmalloc-minimal4 \
      libmagickwand-6.q16-3 \
      at-spi2-core \
      procps \
      x11vnc \
  # Install libpng12-0 from xenial
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 \
  && echo "deb http://security.ubuntu.com/ubuntu xenial-security main" > /etc/apt/sources.list.d/xenial-security.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libpng12-0 \
  # Install git from backports
  && DEBIAN_FRONTEND=noninteractive apt-get -t stretch-backports install -y --no-install-recommends \
    git \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.UTF-8

RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && rm -rf /tmp/s6-overlay-amd64.tar.gz

RUN groupadd -r usr1cv8 --gid=2001 \
  && useradd -r -g usr1cv8 --uid=2001 --home-dir=/home/usr1cv8 --shell=/sbin/nologin usr1cv8 \
  && mkdir -p /home/usr1cv8/.1cv8 \
  && mkdir -p /home/usr1cv8/.1C/1cestart \
  && chown -R usr1cv8:usr1cv8 /home/usr1cv8

COPY ./configs/client-vnc/rootfs/ /
RUN mkdir -p /opt/1cv8/x86_64/${ONEC_VERSION}/conf \
  && ln -s /opt/1C/v8.3/x86_64/conf /opt/1cv8/x86_64/${ONEC_VERSION}/conf

ENV DISPLAY=:0
ENV DISPLAY_WIDTH=1440
ENV DISPLAY_HEIGHT=900

EXPOSE 5900

ENTRYPOINT ["/init"]
