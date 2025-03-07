# Описание

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

В данном репозитории находятся файлы для сборки образов [Docker](https://www.docker.com) с платформой [1С:Предприятие](http://v8.1c.ru) 8.3.

# Оглавление

- [Описание](#описание)
- [Использование](#использование)
  - [Как запустить в docker-compose](#как-запустить-в-docker-compose)
  - [Как использовать готовые дистрибутивы](#как-использовать-готовые-дистрибутивы)
  - [Как использовать nethasp.ini в Jenkins + Docker Swarm plugin](#как-использовать-nethaspini-в-jenkins--docker-swarm-plugin)
- [Оглавление](#оглавление)
  - [EDT](#edt)
  - [Сервер](#сервер)
  - [Клиент](#клиент)
  - [Клиент с поддержкой VNC](#клиент-с-поддержкой-vnc)
  - [Хранилище конфигурации](#хранилище-конфигурации)
  - [ПУСК](#пуск)


# Использование
Нужен регистри, например
```shell
docker run -d -p 5000:5000 --name registry --restart always -v local-registry-data:/var/lib/registry registry:2
```
Проверяем доступность регистри
```shell
curl -s -i -X GET http://registry.localhost:5000/v2/_catalog
```

Создайте файл `.env` содержащий перменные среды
 * `ONEC_USERNAME` и `ONEC_PASSWORD` - логин и пароль от информационно технологического сопровождения http://releases.1c.ru
 * `ONEC_VERSION` - какую версию 1С использовать
 * `EDT_VERSION` - какую версию ЕДТ использовать
 * `DOCKER_` - доступный для пуша регистри для контейнеров
 * `DOCKER_SYSTEM_PRUNE` - очистить перед сборкой незапущенные локальные контейнеры, неиспользуемые запущенными контейнерами тома, неиспользуемые запущенными контейнерами образы, используйте с осторожностью
```
ONEC_USERNAME=0000000
ONEC_PASSWORD=password
ONEC_VERSION=8.3.25.1546
EDT_VERSION=2024.2.3

DOCKER_REGISTRY_URL=localhost:5000
DOCKER_LOGIN=login
DOCKER_PASSWORD=pass
DOCKER_SYSTEM_PRUNE=false
```

чего на bat и sh - не проврял, проверял исправлял скрипты ps1, выполнение скриптов предполагается в корневой директории (там где они лежат), в другой - не будет работать

## Как использовать готовые дистрибутивы
Вы можете использовать готовые дистрибутивы платформы, для этого достаточно разместить их в папке `distr`. Скрипты будут автоматически использовать их для сборки образа.
(не проверял, в каком виде их класть не понятно)

## Как использовать nethasp.ini в Jenkins + Docker Swarm plugin

- взять ваш файл nethasp.ini
- создать из него docker config командой `docker config create nethasp.ini ./nethasp.ini`
- в Jenkins, в настройках Docker Agent templates у соответствующих агентов в параметре Configs указать `nethasp.ini:/opt/1cv8/current/conf/nethasp.ini`

## EDT
`./build-edt.ps1`

Пример использования, временная или нет рабочей области, файлы src проекта EDT находятся здесь `D:\Projects\sample-onec-ws\sample-onec\edt-project\src`
```shell
docker run --rm -v "D:\Projects:/home/projects" -v "C:\Temp:/tmp/work" localhost:5000/edt:2024.2.3 1cedtcli -data "/tmp/tmp-edt-ws" -command export --project "/home/projects/sample-onec-ws/sample-onec/edt-project" --configuration-files "/tmp/work/1-0-0-1-3df46495/"
```
в результате в `C:\Temp\1-0-0-1-3df46495` имеем конфигурационные файлы в формате 1С

Пример использования, ранее созданная рабочая область находится здесь `D:/Projects/slk-ws`, в рабочей области есть проект с именем `acc3-edt`
```shell
docker run --rm -v "D:\Projects:/home/projects" -v "C:\Temp:/tmp/work" localhost:5000/edt:2024.2.3  1cedtcli -data "/home/projects/slk-ws" -command export --project-name "acc3-edt" --configuration-files "/tmp/work/3-0-177-16-d9104849/"
```
в результате изредка в `C:\Temp\3-0-177-16-d9104849` конфигурационные файлы в формате 1С

## Сервер
`./build-server.ps1`

пример использования:
```shell
docker run --rm localhost:5000/onec-server:8.3.25.1546 /opt/1cv8/current/ibcmd --version
```

## Клиент
`./build-client.ps1`

пример использования обновление конфигурации базы данных:
```shell
docker run --rm -v "E:\Issues\sample-onec:/home/dbpath" localhost:5000/onec-client:8.3.25.1546 /opt/1cv8/current/1cv8 DESIGNER /F"/home/dbpath" /UpdateDBCfg /DisableStartupDialogs /DisableStartupMessages /Out /home/dbpath/.log -NoTruncate
```
в файле `E:\Issues\sample-onec\.log` - дописываются ошибки

## Клиент с поддержкой VNC
`./build-client-vnc.ps1`

Для проверки запускаем, на порту 5900 например с помошью RealVNC видим запущенную среду, можно добавить базу из каталога /home/dbpath
```shell
docker run --rm -p 5900:5900 -v "E:\Issues\sample-onec:/home/dbpath" localhost:5000/onec-client-vnc:8.3.25.1546
```

## Хранилище конфигурации
### Хранилище на tcp
`./build-crs.ps1`

Проверка: запустить
```shell
docker run --rm -v "C:\Temp\crs:/home/usr1cv8/.1cv8/crs" -p 1542:1542 localhost:5000/crs:8.3.25.1546
```
попробовать создать хранилище tcp://localhost:1542/sample-svn

### Хранилище на http
`./build-crs-apache.ps1`

Проверка
```shell
docker run --rm -v "C:\Temp\crs:/home/usr1cv8/.1cv8/crs" -p 1548:80 localhost:5000/crs-apache:8.3.25.1546
```
ранее созданное хранилище должно быть доступно тут http://localhost:1548/crs/repo.1ccr/sample-svn

## ПУСК
`./build-pusk.ps1`

Проверка: `pusk/application.properties.example` положить в `C:\Temp\pusk\data\application.properties`, в `C:\Temp\pusk\log` - журналы
```shell
docker run --rm -v "C:\Temp\pusk\log:/opt/pusk/log" -v "C:\Temp\pusk\data:/opt/pusk/data" -p 8085:8080 localhost:5000/pusk:1.2.1
```
браузер localhost:8085 видим что-то хорошее, управление сервисами - не работает.