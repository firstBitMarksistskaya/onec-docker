ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE=debian
ARG BASE_TAG=bookworm-slim

FROM ${DOCKER_REGISTRY_URL:+"$DOCKER_REGISTRY_URL/"}${BASE_IMAGE}:${BASE_TAG}

# Installing mono and oscript dependencies
ARG MONO_VERSION=6.12.0.122

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      gnupg \
      dirmngr \
      wget \
      libicu-dev \
      pkg-config \
  && mkdir -p -m 0755 /etc/apt/keyrings \
  && wget -qO- 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF' | \
    gpg --dearmor -o /etc/apt/keyrings/mono-official-stable.gpg \
  # Mono публикует отдельные репозитории под дистрибутив: Debian -> stable-buster, Ubuntu -> stable-focal.
  # Подбираем подходящий по фактическому базовому образу (BASE_IMAGE/BASE_TAG могут быть любыми).
  && . /etc/os-release \
  && if [ "$ID" = "debian" ]; then mono_repo="debian stable-buster"; else mono_repo="ubuntu stable-focal"; fi \
  && echo "deb [signed-by=/etc/apt/keyrings/mono-official-stable.gpg] https://download.mono-project.com/repo/$mono_repo main" \
    > /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    mono-runtime \
    ca-certificates-mono \
    libmono-i18n4.0-all \
    libmono-system-runtime-serialization4.0-cil \
  && rm -rf /etc/apt/sources.list.d/mono-official-stable.list /etc/apt/keyrings/mono-official-stable.gpg \
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
ARG OVM_VERSION=v1.6.1
ARG ONESCRIPT_VERSION=stable
ARG ONESCRIPT_PACKAGES="add gitsync vanessa-runner stebi edt-ripper"

RUN wget https://github.com/${OVM_REPOSITORY_OWNER}/ovm/releases/download/${OVM_VERSION}/ovm.exe \
  && mv ovm.exe /usr/local/bin/ \
  && echo 'mono /usr/local/bin/ovm.exe "$@"' | tee /usr/local/bin/ovm \
  && chmod +x /usr/local/bin/ovm \
  && ovm use --install ${ONESCRIPT_VERSION}

ENV OSCRIPTBIN=/root/.local/share/ovm/current/bin
ENV PATH="$OSCRIPTBIN:$PATH"

# Update and prepare oscript packages
# vanessa-runner from ONESCRIPT_PACKAGES is pinned to VANESSA_RUNNER_VERSION, the latest one is installed if it is empty.
# Declared here so that changing the version does not rebuild the layers above.
ARG VANESSA_RUNNER_VERSION
RUN if [ -n "$VANESSA_RUNNER_VERSION" ]; then \
       ONESCRIPT_PACKAGES=$(echo " $ONESCRIPT_PACKAGES " | sed "s/ vanessa-runner / vanessa-runner@$VANESSA_RUNNER_VERSION /"); \
     fi \
  && opm install opm \
  && opm update --all \
  && opm install ${ONESCRIPT_PACKAGES} \
  && if echo "$ONESCRIPT_PACKAGES" | grep -q "gitsync"; then \
       gitsync plugins init \
       && gitsync plugins enable limit \
       && gitsync plugins disable limit; \
     fi

COPY ./oscript/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
