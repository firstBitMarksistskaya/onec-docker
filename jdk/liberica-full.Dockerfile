FROM debian:11-slim

ARG JDK_VERSION=11

WORKDIR /tmp

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    # downloader dependencies
    curl \
    gpg \
    gpg-agent \
    ca-certificates \
    locales \
  && curl -s https://download.bell-sw.com/pki/GPG-KEY-bellsoft | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/bellsoft.gpg --import \
  && echo "deb [arch=amd64] https://apt.bell-sw.com/ stable main" | tee /etc/apt/sources.list.d/bellsoft.list \
  && chmod 755 /etc/apt/trusted.gpg.d/bellsoft.gpg \
  && apt-get update \
  && apt-get install bellsoft-java${JDK_VERSION}-full --no-install-recommends -y \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/* \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8