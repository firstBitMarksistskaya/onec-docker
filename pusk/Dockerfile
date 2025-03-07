FROM bellsoft/liberica-openjdk-debian:17

ADD https://it-expertise.ru/pusk/ite-pusk-1.2.1.tar.gz /tmp/
ADD https://its.1c.ru/db/files/1CITS/EXE/java-api-8.3.11/java-api-8.3.11.zip /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/s6-overlay-installer

COPY ./configs/pusk/rootfs/ /

RUN apt-get update \
  && apt-get install --yes \
    locales \
    procps \
    unzip \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen ru_RU.UTF-8 \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 \
  && tar xzf /tmp/ite-pusk-1.2.1.tar.gz -C /opt/ \
  && rm -rf /tmp/ite-pusk-1.2.1.tar.gz \
  && chmod +x /opt/pusk/ite-pusk-linux.sh \
  && ln -s /usr/lib/jvm/jdk-17.0.14-bellsoft-x86_64/bin/java /usr/bin/java \
  && unzip /tmp/java-api-8.3.11.zip -d /tmp/ \
  && rm -rf /tmp/java-api-8.3.11.zip \
  && unzip /tmp/java-api-8.3.11/java-api-1.6.7.zip -d /tmp/ \
  && rm -rf /tmp/java-api-8.3.11/java-api-1.6.7.zip \
  && unzip /tmp/java-api-1.6.7/com._1c.v8.ibis.admin-1.6.7.zip -d /tmp/ \
  && rm -rf /tmp/java-api-1.6.7/com._1c.v8.ibis.admin-1.6.7.zip \
  && mv /tmp/com._1c.v8.ibis.admin-1.6.7/lib/* /opt/pusk/lib/ \
  && chmod +x /tmp/s6-overlay-installer && /tmp/s6-overlay-installer / \
  && echo '#!/bin/bash\n echo "systemd (systemctl) is not available in this container."\n exit 0' > /usr/local/bin/systemctl \
  && chmod +x /usr/local/bin/systemctl \
  && ln -s /usr/local/bin/systemctl /bin/systemctl

ENV LANG=ru_RU.UTF-8
ENV LANGUAGE=ru_RU:ru
ENV LC_ALL=ru_RU.UTF-8

VOLUME /opt/pusk/data
VOLUME /opt/pusk/log

EXPOSE 8080

WORKDIR /opt/pusk

ENTRYPOINT ["/init"]
