#!/usr/bin/env bash

echo ">>> Provisioning Redis Commander"

npm -g list redis-commander > /dev/null 2>&1
RC_IS_INSTALLED=$?

if [ $RC_IS_INSTALLED -eq 1 ]; then
    echo ">>> Installing Redis Commander"
    npm install -g redis-commander
fi

if [ ! -f /etc/supervisor/conf.d/redis-commander.conf ]; then
    echo ">>> Installing Redis commander supervisor config"

config="[program:redis]

command=redis-commander --redis-port=6379 --redis-host=127.0.0.1 --port=8081
"

    echo "$config" > "/etc/supervisor/conf.d/redis-commander.conf"
fi
