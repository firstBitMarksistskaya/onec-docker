#!/bin/bash

if [ "$1" = "ragent" -a "$onec_8318plus_version" = true ]; then
  exec gosu usr1cv8 /opt/1cv8/x86_64/$onec_ver/ragent
elif [ "$1" = "ragent" ]; then
  exec gosu usr1cv8 /opt/1C/v8.3/x86_64/ragent
fi

exec "$@"
