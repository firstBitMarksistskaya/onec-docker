ARG DOCKER_REGISTRY_URL=localhost:5000
ARG BASE_IMAGE=onec-server
ARG BASE_TAG=8.3.25.1546
FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG} AS onecserver

ADD https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64 /bin/gosu

RUN chmod +x /bin/gosu \
    && mkdir -p /home/usr1cv8/.1cv8/crs \
    && chown -R usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

COPY ./crs/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh \
  && chmod +x /opt/1cv8/current/crserver

VOLUME /home/usr1cv8/.1cv8/crs

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 1542
CMD ["crserver"]
