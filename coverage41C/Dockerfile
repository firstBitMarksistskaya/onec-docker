ARG DOCKER_REGISTRY_URL=library
ARG BASE_IMAGE=edt
ARG BASE_TAG
ARG EDT_VERSION=2021.3
ARG COVERAGE41C_VERSION=2.7.3

FROM ${DOCKER_REGISTRY_URL}/edt:${EDT_VERSION} AS installededt

RUN ln -s $(find /opt/1C -name "com._1c.g5.v8.dt.debug.*.jar" -printf '%h\n'| sort -u) /opt/1C/edt_plugins

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}
LABEL maintainer="Dima Ovcharenko <d.ovcharenko90@gmail.com>, Korus Consulting LLC"

ARG COVERAGE41C_VERSION

COPY --from=installededt /opt/1C/edt_plugins/com._1c.g5.v8.dt.debug.core_*.jar /opt/1C/edt_plugins/com._1c.g5.v8.dt.debug.model_*.jar /opt/1C/1CE/

ADD https://github.com/1c-syntax/Coverage41C/releases/download/v${COVERAGE41C_VERSION}/Coverage41C-${COVERAGE41C_VERSION}.tar \
    /opt/

RUN tar xf /opt/Coverage41C-${COVERAGE41C_VERSION}.tar -C /opt/ \
  && rm -rf /opt/Coverage41C-${COVERAGE41C_VERSION}.tar

ENV EDT_LOCATION="/opt/1C/1CE/"
ENV PATH="/opt/Coverage41C-${COVERAGE41C_VERSION}/bin:$PATH"
