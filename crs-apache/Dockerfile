ARG DOCKER_USERNAME
ARG ONEC_VERSION

FROM ${DOCKER_USERNAME}/onec-crs:${ONEC_VERSION}

ARG REPO_DIR=/home/usr1cv8/.1cv8/repo

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    apache2 \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/*

COPY ./crs-apache/1crs.conf /etc/apache2/conf-available/
RUN ln -s /etc/apache2/conf-available/1crs.conf /etc/apache2/conf-enabled/1crs.conf
RUN echo "export APACHE_RUN_DIR=/etc/apache2\$SUFFIX" >> /etc/apache2/envvars \
  && echo "export APACHE_PID_FILE=/etc/apache2\$SUFFIX/apache2.pid" >> /etc/apache2/envvars 

COPY ./crs-apache/repo.1ccr /home/usr1cv8/.1cv8
RUN mkdir -p ${REPO_DIR}

COPY ./crs-apache/docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80
