#!/usr/bin/env bash

echo ">>> Installing MongoDB"

mongod --version > /dev/null 2>&1
MONGO_IS_INSTALLED=$?

if [ $MONGO_IS_INSTALLED -eq 0 ]; then
    echo ">>> MongoDB already installed"
    service mongod restart
else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/steveneaston/Vaprobash/master/scripts/mongodb.sh)" bash $1 $2
fi
