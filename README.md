# Описание

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

В данном репозитории находятся файлы для сборки образов [Docker](https://www.docker.com) с платформой [1С:Предприятие](http://v8.1c.ru) 8.3.

## Оглавление

- [Описание](#описание)
  - [Оглавление](#оглавление)
  - [Использование](#использование)
  - [Как сбилдить образы](#как-сбилдить-образы)
  - [Как использовать готовые дистрибутивы](#как-использовать-готовые-дистрибутивы)
  - [Как использовать образы в Jenkins в режиме Docker Swarm](#как-использовать-образы-в-jenkins-в-режиме-docker-swarm)
    - [Настройка nethasp.ini](#настройка-nethaspini)
  - [Сервер](#сервер)
  - [Сервер с дополнительными языками](#сервер-с-дополнительными-языками)
  - [Клиент](#клиент)
  - [Клиент с поддержкой VNC](#клиент-с-поддержкой-vnc)
  - [Клиент с дополнительными языками](#клиент-с-дополнительными-языками)
  - [SonarScanner](#sonarscanner)
  - [Тонкий клиент](#тонкий-клиент)
  - [Тонкий клиент с дополнительными языками](#тонкий-клиент-с-дополнительными-языками)
  - [Хранилище конфигурации](#хранилище-конфигурации)
  - [rac-gui](#rac-gui)
  - [gitsync](#gitsync)
  - [oscript](#oscript)
  - [vanessa-runner](#vanessa-runner)
  - [EDT](#edt)
  - [Исполнитель](#исполнитель)

## Использование

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

- ONEC_USERNAME - учётная запись на [releases.1c.ru](https://releases.1c.ru)
- ONEC_PASSWORD - пароль для учётной записи на [releases.1c.ru](https://releases.1c.ru)
- ONEC_VERSION - версия платформы 1С:Преприятия 8.3, которая будет в образе
- EDT_VERSION - версия EDT. Обязательно заполнять только при сборке образов с EDT или при использовании замеров покрытия (см. `COVERAGE41C_VERSION`)
- OPENJDK_VERSION - версия JDK (temurin)
- DOCKER_REGISTRY_URL - Адрес Docker-registry в котором будут храниться образы
- COVERAGE41C_VERSION - версия Coverage41C
Используется при сборке агента скриптами `build-base-*-jenkins-coverage-agent.*`.
- VANESSA_RUNNER_VERSION - версия vanessa-runner, например `2.6.1`. Если не указана, устанавливается последняя версия.
Используется при сборке образов с OneScript скриптами `build-base-*-jenkins-agent.*` (в том числе из `build-base-*-jenkins-coverage-agent.*`) и `build-oscript-*-agent.*`.
- DEV1C_EXECUTOR_API_KEY - токен для api скачивания 1С:Исполнитель с сайта developer.1c.ru
- EXECUTOR_VERSION - версия 1С:Исполнитель для сборки
- TEST_UTILS_EXTRA_PACKAGES - дополнительные пакеты, которые будут установлены при сборке `test-utils` и которые будут доступны в финальном образе

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

    - build-base-swarm-jenkins-agent.sh (или build-base-swarm-jenkins-coverage-agent.sh с замерами покрытия)
    - build-edt-swarm-agent.sh
    - build-oscript-swarm-agent.sh

2. Если же вы планируете использовать k8s:

    - build-base-k8s-jenkins-agent.sh (или build-base-k8s-jenkins-coverage-agent.sh с замерами покрытия)
    - build-edt-k8s-agent.sh
    - build-oscript-k8s-agent.sh

3. Отдельные образы:

    - build-server.sh
    - build-crs.sh
    - build-executor.sh
    - build-sonar-scanner.sh

## Как использовать готовые дистрибутивы

Вы можете использовать готовые дистрибутивы платформы, для этого достаточно разместить их в папке `distr`. Скрипты будут автоматически использовать их для сборки образа.

## Как использовать образы в Jenkins в режиме Docker Swarm

Поддерживаемые плагины:

- [Swarm Agents Cloud](https://plugins.jenkins.io/swarm-agents-cloud/)

> ⚠️ ВНИМАНИЕ! При настройке шаблонов агентов в плагине Swarm Agents Cloud необходимо раскрыть раздел `Advanced` и установить флажок `Disable Container Args`.

- [Docker Swarm (устарел)](https://plugins.jenkins.io/docker-swarm/)

### Настройка nethasp.ini

- взять ваш файл nethasp.ini
- создать из него docker config командой `docker config create nethasp.ini ./nethasp.ini`
- в Jenkins, в настройках Docker Agent templates у соответствующих агентов в параметре Configs указать `nethasp.ini:/opt/1cv8/current/conf/nethasp.ini`

## Сервер

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-server:${ONEC_VERSION} \
  -f server/Dockerfile .
```

## Сервер с дополнительными языками

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg nls_enabled=true \
  -t ${DOCKER_REGISTRY_URL}/onec-server-nls:${ONEC_VERSION} \
  -f server/Dockerfile .
```

## Клиент

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-client:${ONEC_VERSION} \
  -f client/Dockerfile .
```

## Клиент с поддержкой VNC

[(Наверх)](#оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-client-vnc:${ONEC_VERSION} \
  -f client-vnc/Dockerfile .
```

## Клиент с дополнительными языками

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg nls_enabled=true \
  -t ${DOCKER_REGISTRY_URL}/onec-client-nls:${ONEC_VERSION} \
  -f client/Dockerfile .
```

## SonarScanner

[(Наверх)](#оглавление)

Образ с [SonarScanner CLI](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/) поверх слоёв `client` + `jdk` (без поддержки VNC). Java предоставляется слоем `jdk`, автоскачивание JRE с сервера отключено (`SONAR_SCANNER_SKIP_JRE_PROVISIONING=true`). SonarScanner CLI 8.x требует Java 21+, поэтому скрипт сборки собирает слой `jdk` с JDK 25 (`SONAR_JDK_VERSION`, по умолчанию `25`). Для сборки всей цепочки слоёв (`client` → `jdk` → `sonar-scanner`) используйте скрипт `build-sonar-scanner.sh` (или `build-sonar-scanner.bat` в Windows).

Либо вручную, поверх уже собранного образа `onec-client` (см. раздел [Клиент](#клиент)) — сначала слой `jdk`, затем `sonar-scanner`:

```bash
# слой jdk поверх client
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg BASE_IMAGE=onec-client \
  --build-arg BASE_TAG=${ONEC_VERSION} \
  --build-arg OPENJDK_VERSION=25 \
  -t ${DOCKER_REGISTRY_URL}/onec-client-jdk:${ONEC_VERSION} \
  -f jdk/Dockerfile .

# слой sonar-scanner поверх client + jdk
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg BASE_IMAGE=onec-client-jdk \
  --build-arg BASE_TAG=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-sonar-scanner:${ONEC_VERSION} \
  -f sonar-scanner/Dockerfile .
```

## Тонкий клиент

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-thin-client:${ONEC_VERSION} \
  -f thin-client/Dockerfile .
```

## Тонкий клиент с дополнительными языками

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg nls_enabled=true \
  -t ${DOCKER_REGISTRY_URL}/onec-thin-client-nls:${ONEC_VERSION} \
  -f thin-client/Dockerfile .
```

## Хранилище конфигурации

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-crs:${ONEC_VERSION} \
  -f crs/Dockerfile .
```

## rac-gui

[(Наверх)](#оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/onec-rac-gui:${ONEC_VERSION}-1.0.1 \
  -f rac-gui/Dockerfile .
```

## gitsync

[(Наверх)](#оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/gitsync:3.0.0 \
  -f gitsync/Dockerfile .
```

## oscript

[(Наверх)](#оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg VANESSA_RUNNER_VERSION=${VANESSA_RUNNER_VERSION} \
  -t ${DOCKER_REGISTRY_URL}/oscript:1.0.21 \
  -f oscript/Dockerfile .
```

## vanessa-runner

[(Наверх)](#оглавление)

```bash
docker build --build-arg DOCKER_REGISTRY_URL=${DOCKER_REGISTRY_URL} \
  -t ${DOCKER_REGISTRY_URL}/runner:1.7.0 \
  -f vanessa-runner/Dockerfile .
```

## EDT

[(Наверх)](#оглавление)

```bash
docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
    --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
    --build-arg EDT_VERSION=${EDT_VERSION} \
    -t ${DOCKER_REGISTRY_URL}/edt:${EDT_VERSION} \
    -f edt/Dockerfile .
```

## Исполнитель

[(Наверх)](#оглавление)

```bash
./build-executor.sh
```

Собирать обязательно через запуск скрипта, так как в нём реализован безопасный проброс секретов в окружение сборки
