#!/bin/bash

if [ "$1" = "crserver" ]; then
  exec gosu usr1cv8 /opt/1cv8/i386/$onec_ver/crserver -port 1542 -d /home/usr1cv8/.1cv8
fi

exec "$@"
