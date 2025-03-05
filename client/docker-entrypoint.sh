#!/bin/bash

PATH="/opt/1cv8/current:$PATH"

# Запускаем Xvfb в фоновом режиме, надо для 1cv8, 1cv8c или 1cv8s
Xvfb :1 -screen 0 1024x768x24 &
export DISPLAY=:1

# Запускаем переданную команду
exec "$@"
