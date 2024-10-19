# Описание

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

В данном репозитории находятся файлы для сборки образов [Docker](https://www.docker.com) с платформой [1С:Предприятие](http://v8.1c.ru) 8.3.

# Оглавление

- [Описание](#описание)
- [Использование](#использование)
  - [Как сбилдить образы](#как-сбилдить-образы)
  - [Как запустить в docker-compose](#как-запустить-в-docker-compose)
  - [Как использовать готовые дистрибутивы](#как-использовать-готовые-дистрибутивы)
  - [Как использовать nethasp.ini в Jenkins + Docker Swarm plugin](#как-использовать-nethaspini-в-jenkins--docker-swarm-plugin)
- [Оглавление](#оглавление)
  - [Сервер](#сервер)
  - [Сервер с дополнительными языками](#сервер-с-дополнительными-языками)
  - [Клиент](#клиент)
  - [Клиент с поддержкой VNC](#клиент-с-поддержкой-vnc)
  - [Клиент с дополнительными языками](#клиент-с-дополнительными-языками)
  - [Тонкий клиент](#тонкий-клиент)
  - [Тонкий клиент с дополнительными языками](#тонкий-клиент-с-дополнительными-языками)
  - [Хранилище конфигурации](#хранилище-конфигурации)
  - [rac-gui](#rac-gui)
  - [gitsync](#gitsync)
  - [oscript](#oscript)
  - [vanessa-runner](#vanessa-runner)
  - [EDT](#edt)

# Использование

В терминале введите:

Команда Linux:
```bash
# для Linux
$ cp .onec.env.example .onec.env
```
```batch
:: для Windows
copy .onec.env.bat.example env.bat
```

Скорректируйте файл `.onec.env` в соответствии со своим окружением:

* ONEC_USERNAME - учётная запись на http://releases.1c.ru
* ONEC_PASSWORD - пароль для учётной записи на http://releases.1c.ru
* ONEC_VERSION - версия платформы 1С:Преприятия 8.3, которая будет в образе
* EDT_VERSION - версия EDT. Обязательно заполнять только при сборке образов с EDT или при использовании замеров покрытия (см. `COVERAGE41C_VERSION`)
* DOCKER_REGISTRY_URL - Адрес Docker-registry в котором будут храниться образы
* COVERAGE41C_VERSION - версия Coverage41C
Если заполнено, то при выполнении скриптов `build-base-*-agent.*` будет также собран образ `base-jenkins-coverage-agent`, подготовленный для сбора замеров покрытия с помощью Coverage41C. Требуется также указать значение для переменной EDT_VERSION.

Затем экспортируйте все необходимые переменные:

```bash
# для Linux
$ source .onec.env
```
```batch
:: для Windows
env.bat
```

## Как сбилдить образы

:point_up: Запустите последовательно скрипты для сборки образов.

1. Если вам нужны образы для использования в docker-swarm:

    * build-base-swarm-jenkins-agent.sh
    * build-edt-swarm-agent.sh
    * build-oscript-swarm-agent.sh

2. Если же вы планируете использовать k8s

    * build-base-k8s-jenkins-agent.sh
    * build-edt-k8s-agent.sh
    * build-oscript-k8s-agent.sh

## Как использовать готовые дистрибутивы

Вы можете использовать готовые дистрибутивы платформы, для этого достаточно разместить их в папке `distr`. Скрипты будут автоматически использовать их для сборки образа.

## Как использовать nethasp.ini в Jenkins + Docker Swarm plugin

- взять ваш файл nethasp.ini
- создать из него docker config командой `docker config create nethasp.ini ./nethasp.ini`
- в Jenkins, в настройках Docker Agent templates у соответствующих агентов в параметре Configs указать `nethasp.ini:/opt/1cv8/current/conf/nethasp.ini`

## Сервер
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-server:${ONEC_VERSION} \
  -f server/Dockerfile .
```

## Сервер с дополнительными языками
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg nls_enabled=true \
  -t ${DOCKER_REGISTRY_URL}/onec-server-nls:${ONEC_VERSION} \
  -f server/Dockerfile .
```

## Клиент
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-client:${ONEC_VERSION} \
  -f client/Dockerfile .
```

## Клиент с поддержкой VNC
[(Наверх)](#Оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-client-vnc:${ONEC_VERSION} \
  -f client-vnc/Dockerfile .
```

## Клиент с дополнительными языками
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg nls_enabled=true \
  -t ${DOCKER_REGISTRY_URL}/onec-client-nls:${ONEC_VERSION} \
  -f client/Dockerfile .
```

## Тонкий клиент
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-thin-client:${ONEC_VERSION} \
  -f thin-client/Dockerfile .
```

## Тонкий клиент с дополнительными языками
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg nls_enabled=true \
  -t ${DOCKER_REGISTRY_URL}/onec-thin-client-nls:${ONEC_VERSION} \
  -f thin-client/Dockerfile .
```

## Хранилище конфигурации
[(Наверх)](#Оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-crs:${ONEC_VERSION} \
  -f crs/Dockerfile .
```

## rac-gui
[(Наверх)](#Оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-rac-gui:${ONEC_VERSION}-1.0.1 \
  -f rac-gui/Dockerfile .
```

## gitsync
[(Наверх)](#Оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/gitsync:3.0.0 \
  -f gitsync/Dockerfile .
```

## oscript
[(Наверх)](#Оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/oscript:1.0.21 \
  -f oscript/Dockerfile .
```

## vanessa-runner
[(Наверх)](#Оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  -t ${DOCKER_REGISTRY_URL}/runner:1.7.0 \
  -f vanessa-runner/Dockerfile .
```
## EDT
[(Наверх)](#Оглавление)
```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
    --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
    --build-arg EDT_VERSION=${EDT_VERSION} \
    -t ${DOCKER_REGISTRY_URL}/edt:${EDT_VERSION} \
    -f edt/Dockerfile .
```
