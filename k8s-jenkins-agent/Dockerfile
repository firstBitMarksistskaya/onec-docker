# Для сборки использован стандартный шаблон jenkins-inbound-agent https://github.com/jenkinsci/docker-agent/blob/master/debian/Dockerfile
# Стадию с AS jre-build убрал, т.к. у нас на этот момент уже всегда есть джава в контейнере.
ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE
ARG BASE_TAG

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG} AS agent

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN groupadd -g "${gid}" "${group}" \
  && useradd -l -c "Jenkins user" -d /home/"${user}" -u "${uid}" -g "${gid}" -m "${user}" || echo "user ${user} already exists."

ARG AGENT_WORKDIR=/home/"${user}"/agent

## Always use the latest Debian packages: no need for versions
# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get --yes --no-install-recommends install \
    ca-certificates \
    curl \
    fontconfig \
    git \
    git-lfs \
    less \
    netbase \
    openssh-client \
    patch \
    tzdata \
  && apt-get clean \
  && rm -rf /tmp/* /var/cache/* /var/lib/apt/lists/*

ARG VERSION=3283.v92c105e0f819
ADD --chown="${user}":"${group}" "https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar" /usr/share/jenkins/agent.jar
RUN chmod 0644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir -p /home/"${user}"/.jenkins && mkdir -p "${AGENT_WORKDIR}"

VOLUME /home/"${user}"/.jenkins
VOLUME "${AGENT_WORKDIR}"
WORKDIR /home/"${user}"
ENV USER=${user}
LABEL \
  org.opencontainers.image.vendor="Jenkins project" \
  org.opencontainers.image.title="Official Jenkins Agent Base Docker image" \
  org.opencontainers.image.description="This is a base image, which provides the Jenkins agent executable (agent.jar)" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.url="https://www.jenkins.io/" \
  org.opencontainers.image.source="https://github.com/jenkinsci/docker-agent" \
  org.opencontainers.image.licenses="MIT"

## Inbound Agent image target
FROM agent AS inbound-agent

ARG user=jenkins

USER root
COPY ./k8s-jenkins-agent/jenkins-agent /usr/local/bin/jenkins-agent
COPY ./k8s-jenkins-agent/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /usr/local/bin/jenkins-agent \
    && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave \
    && chmod 755 /docker-entrypoint.sh \
    && chmod +x /docker-entrypoint.sh
# USER ${user}

LABEL \
  org.opencontainers.image.vendor="Jenkins project" \
  org.opencontainers.image.title="Official Jenkins Inbound Agent Base Docker image" \
  org.opencontainers.image.description="This is an image for Jenkins agents using TCP or WebSockets to establish inbound connection to the Jenkins controller" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.url="https://www.jenkins.io/" \
  org.opencontainers.image.source="https://github.com/jenkinsci/docker-agent" \
  org.opencontainers.image.licenses="MIT"

ENTRYPOINT ["/docker-entrypoint.sh"]