#!/usr/bin/env bash

echo ">>> Provisioning PM2"

npm -g list pm2 > /dev/null 2>&1
PM2_IS_INSTALLED=$?

if [ $PM2_IS_INSTALLED -eq 1 ]; then
    echo ">>> Installing PM2"
    npm install -g pm2
fi


if [ ! -f /etc/init/workaround-vagrant-bug-6074.conf ]; then
    echo ">>> Installing PM2 Workaround"

workaround="# workaround for https://github.com/mitchellh/vagrant/issues/6074
start on filesystem
task

env MOUNTPOINT=/var/www

script
#  until mountpoint -q \$MOUNTPOINT; do sleep 1; done
   until (cat /etc/mtab | grep \$MOUNTPOINT); do sleep 1; done
  /sbin/initctl emit --no-wait vagrant-mounted MOUNTPOINT=\$MOUNTPOINT
end script
"

    echo "$workaround" > "/etc/init/workaround-vagrant-bug-6074.conf"
fi

if [ ! -f /etc/init/pm2-upstart.conf ]; then
    echo ">>> Installing PM2 Upstart Script"

upstart="description \"Start pm2 on vagrant-mounted upstart event\"
author      \"Me\"

start on vagrant-mounted

expect fork

setgid vagrant
setuid vagrant

script
 export HOME=/home/vagrant
 sudo /usr/bin/pm2 resurrect
end script
"

    echo "$upstart" > "/etc/init/pm2-upstart.conf"
fi

export HOME=/home/vagrant

pm2 resurrect || {
    status=$?
}
