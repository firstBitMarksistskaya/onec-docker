ARG EDT_VERSION=2021.3.4
ARG BASE_IMAGE=edt
ARG DOCKER_USERNAME

FROM ${DOCKER_USERNAME}/${BASE_IMAGE}:${EDT_VERSION}

ARG REPOSITORY_URL
ARG PACKAGE_NAMES

RUN edt_path=$(ring edt locations list) \
  && $edt_path/1cedt \
  -clean -purgeHistory \
  -application org.eclipse.equinox.p2.director \
  -noSplash \
  -repository ${REPOSITORY_URL} \
  -installIUs ${PACKAGE_NAMES}