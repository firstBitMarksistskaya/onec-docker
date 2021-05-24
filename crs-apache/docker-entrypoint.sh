#!/bin/bash

# start crserver
exec gosu usr1cv8 /opt/1cv8/i386/$onec_ver/crserver -port 1542 -d /home/usr1cv8/.1cv8/repo -daemon &

# start apache2
source /etc/apache2/envvars
exec /usr/sbin/apache2 -DFOREGROUND
