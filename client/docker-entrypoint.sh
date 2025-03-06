#!/bin/bash

PATH="/opt/1cv8/current:$PATH"

# Запускаем Xvfb в фоновом режиме, надо для 1cv8, 1cv8c или 1cv8s
Xvfb $DISPLAY -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24 &

# Запускаем переданную команду
exec "$@"
