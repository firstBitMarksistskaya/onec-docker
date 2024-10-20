ARG DOCKER_USERNAME=library
ARG BASE_IMAGE=adoptopenjdk
ARG BASE_TAG=14-hotspot

FROM ${DOCKER_USERNAME}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Alexey Sosnoviy<Labotamy@gmail.com>"

ARG coverage_ver=2.7.1

COPY ./distr/edtlibs/ /edtlibs/

ENV EDT_LOCATION="/edtlibs"

ADD https://github.com/1c-syntax/Coverage41C/releases/download/v$coverage_ver/Coverage41C-$coverage_ver.tar Coverage41C.tar

RUN mkdir /opt/Coverage41C \
  && tar -xf Coverage41C.tar \
  && cp -a Coverage41C-$coverage_ver/. /opt/Coverage41C/ \
  && rm Coverage41C.tar \
  && rm -r Coverage41C-$coverage_ver

ENTRYPOINT [ "/opt/Coverage41C/bin/Coverage41C" ]
