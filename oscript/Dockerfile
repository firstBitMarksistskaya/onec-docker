ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE=debian
ARG BASE_TAG=bookworm-slim

FROM ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}${BASE_IMAGE}:${BASE_TAG}

RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until \
    && apt-get update

# Установка часового пояса Новосибирск ( ДОБАВЛЕНО )
ENV TZ=Asia/Novosibirsk
RUN apt-get update \
  && apt-get install -y --no-install-recommends tzdata \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/*

# Установка зависимостей mono и oscript
ARG MONO_VERSION=6.12.0.122

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      gnupg \
      dirmngr \
      wget \
      libicu-dev \
      pkg-config \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian stable-buster main" > /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    mono-runtime \
    ca-certificates-mono \
    libmono-i18n4.0-all \
    libmono-system-runtime-serialization4.0-cil \
  && rm -rf /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && cert-sync --user /etc/ssl/certs/ca-certificates.crt \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/*

# Удаление сертификата DST Root CA X3, если он существует
COPY ./scripts/remove-dst-root-ca-x3.sh /remove-dst-root-ca-x3.sh
RUN chmod +x /remove-dst-root-ca-x3.sh \
  && /remove-dst-root-ca-x3.sh \
  && rm /remove-dst-root-ca-x3.sh

# Installing oscript
ARG OVM_REPOSITORY_OWNER=oscript-library
ARG OVM_VERSION=v1.6.1
ARG ONESCRIPT_VERSION=2.1.0
ARG ONESCRIPT_PACKAGES="vanessa-runner"
ARG ADD_VERSION="6.9.6"

RUN wget https://github.com/${OVM_REPOSITORY_OWNER}/ovm/releases/download/${OVM_VERSION}/ovm.exe \
  && mv ovm.exe /usr/local/bin/ \
  && echo 'mono /usr/local/bin/ovm.exe "$@"' | tee /usr/local/bin/ovm \
  && chmod +x /usr/local/bin/ovm \
  && ovm use --install ${ONESCRIPT_VERSION}

ENV OSCRIPTBIN=/root/.local/share/ovm/current/bin
ENV PATH="$OSCRIPTBIN:$PATH"

# Обновление и подготовка пакетов oscript
RUN opm install opm \
  && opm update --all \
  && opm install ${ONESCRIPT_PACKAGES} \
  && if echo "$ONESCRIPT_PACKAGES" | grep -q "gitsync"; then \
       gitsync plugins init \
       && gitsync plugins enable limit \
       && gitsync plugins disable limit; \
     fi

COPY oscript/add-6.9.5.ospx /tmp/add.ospx
RUN opm install -f /tmp/add.ospx \
    && rm /tmp/add.ospx

COPY ./oscript/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
