ARG DOCKER_REGISTRY_URL=library
ARG BASE_IMAGE=edt
ARG BASE_TAG
ARG EDT_VERSION=2021.3
ARG COVERAGE41C_VERSION=2.7.2
ARG EDT_PLUGINS=/opt/1C/1CE/components/1c-edt-${EDT_VERSION}*-x86_64/plugins

FROM ${DOCKER_REGISTRY_URL}/edt:${EDT_VERSION} as base

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Dima Ovcharenko <d.ovcharenko90@gmail.com>, Korus Consulting LLC"

ARG COVERAGE41C_VERSION
ARG EDT_PLUGINS

COPY --from=base ${EDT_PLUGINS}/com._1c.g5.v8.dt.debug.core_*.jar ${EDT_PLUGINS}/com._1c.g5.v8.dt.debug.model_*.jar /opt/1C/1CE/

ADD https://github.com/1c-syntax/Coverage41C/releases/download/v${COVERAGE41C_VERSION}/Coverage41C-${COVERAGE41C_VERSION}.tar \
    /opt/

RUN tar xf /opt/Coverage41C-${COVERAGE41C_VERSION}.tar -C /opt/ \
  && rm -rf /opt/Coverage41C-${COVERAGE41C_VERSION}.tar

ENV EDT_LOCATION="/opt/1C/1CE/"
ENV PATH="/opt/Coverage41C-${COVERAGE41C_VERSION}/bin:$PATH"
