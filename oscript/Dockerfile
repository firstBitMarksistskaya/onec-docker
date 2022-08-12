ARG DOCKER_USERNAME=library
ARG BASE_IMAGE=ubuntu
ARG BASE_TAG=20.04

FROM ${BASE_IMAGE}:${BASE_TAG}

# Installing build dependencies and locale

ARG LANGUAGE_PACK=${LANGUAGE_PACK}
ARG BUILD_LANGUAGE=${BUILD_LANGUAGE}
ARG BUILD_LANG=${BUILD_LANG}
ARG BUILD_LC_ALL=${BUILD_LC_ALL}

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      gnupg \
      ca-certificates \
      wget \
      locales \
      ${LANGUAGE_PACK}

ENV LANGUAGE ${BUILD_LANGUAGE}
ENV LANG ${BUILD_LANG}
ENV LC_ALL ${BUILD_LC_ALL}

RUN locale-gen ${BUILD_LC_ALL} \
  && dpkg-reconfigure locales


# Installing mono and oscript dependencies
RUN wget -q http://download.mono-project.com/repo/xamarin.gpg -O- | apt-key add - \
  && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" > /etc/apt/sources.list.d/mono-official-stable.list \
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

# remove DST Root CA X3 cert if it exists
COPY ./scripts/remove-dst-root-ca-x3.sh /remove-dst-root-ca-x3.sh
RUN chmod +x /remove-dst-root-ca-x3.sh \
  && /remove-dst-root-ca-x3.sh \
  && rm /remove-dst-root-ca-x3.sh

# Installing oscript
ARG OVM_REPOSITORY_OWNER=oscript-library
ARG OVM_VERSION=v1.0.0-RC15
ARG ONESCRIPT_PACKAGES="add gitsync vanessa-runner stebi"
ARG ONESCRIPT_VERSION=${ONESCRIPT_VERSION}

RUN wget https://github.com/${OVM_REPOSITORY_OWNER}/ovm/releases/download/${OVM_VERSION}/ovm.exe \
  && mv ovm.exe /usr/local/bin/ \
  && echo 'mono /usr/local/bin/ovm.exe "$@"' | tee /usr/local/bin/ovm \
  && chmod +x /usr/local/bin/ovm \
  && ovm use --install ${ONESCRIPT_VERSION}

ENV OSCRIPTBIN=/root/.local/share/ovm/current/bin
ENV PATH="$OSCRIPTBIN:$PATH"

# Update and prepare oscript packages
RUN opm install opm \
  && opm update --all \
  && opm install ${ONESCRIPT_PACKAGES} \
  && gitsync plugins init \
  && gitsync plugins enable limit \
  && gitsync plugins disable limit

COPY ./oscript/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
