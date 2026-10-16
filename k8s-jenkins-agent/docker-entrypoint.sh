#!/bin/sh

# s6-overlay v3 работает только первым процессом контейнера (pid 1): запущенный в фоне /init
# сразу завершается, и службы образа (Xvfb и другие) не стартуют. Поэтому jenkins-agent
# запускается основной командой s6-overlay: сначала поднимаются службы, затем агент,
# а когда агент завершается, s6-overlay останавливает контейнер.
# Если pid 1 занят другим процессом (shareProcessNamespace в поде, docker run --init),
# агент запускается без служб образа, как до перехода на s6-overlay v3.
if [ -f "/init" ]; then
    if [ "$$" -eq 1 ]; then
        exec /init /usr/local/bin/jenkins-agent "$@"
    fi
    echo "docker-entrypoint.sh: warning: pid 1 занят другим процессом, s6-overlay не запущен, службы образа (Xvfb и другие) недоступны" >&2
fi

exec /usr/local/bin/jenkins-agent "$@"
