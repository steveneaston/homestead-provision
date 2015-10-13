#!/usr/bin/env bash

echo ">>> Provisioning Redis Commander"

npm -g list redis-commander > /dev/null 2>&1
RC_IS_INSTALLED=$?

if [ $RC_IS_INSTALLED -eq 1 ]; then
    echo ">>> Installing Redis Commander"
    npm install -g redis-commander
    export HOME=/home/vagrant
fi

pm2 start redis-commander
