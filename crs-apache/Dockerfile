ARG DOCKER_REGISTRY_URL=localhost:5000
ARG ONEC_VERSION=8.3.25.1546

FROM ${DOCKER_REGISTRY_URL}/crs:${ONEC_VERSION}

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
    apache2 \
  && rm -rf /var/lib/apt/lists/* /var/cache/debconf

COPY ./crs-apache/1crs.conf /etc/apache2/conf-available/
RUN ln -s /etc/apache2/conf-available/1crs.conf /etc/apache2/conf-enabled/1crs.conf \
  && echo "export APACHE_RUN_DIR=/etc/apache2\$SUFFIX" >> /etc/apache2/envvars \
  && echo "export APACHE_PID_FILE=/etc/apache2\$SUFFIX/apache2.pid" >> /etc/apache2/envvars 

COPY ./crs-apache/repo.1ccr /home/usr1cv8/.1cv8/crsweb/

COPY ./crs-apache/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

VOLUME /home/usr1cv8/.1cv8/crs

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80