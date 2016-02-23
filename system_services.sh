#!/bin/sh
set -e
export LC_ALL=C
set -x

#adding testing repository 
echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk --no-cache upgrade

## Install init process.
cp /build/bin/my_init /sbin/
chmod 750 /sbin/my_init
mkdir -p /etc/my_init.d
mkdir -p /etc/container_environment
touch /etc/container_environment.sh
touch /etc/container_environment.json
chmod 700 /etc/container_environment

addgroup -g 8377 docker_env
chown :docker_env /etc/container_environment.sh /etc/container_environment.json
chmod 640 /etc/container_environment.sh /etc/container_environment.json
ln -s /etc/container_environment.sh /etc/profile.d/

## Install runit.
apk --no-cache add runit

## Install a syslog daemon.
apk --no-cache add syslog-ng
mkdir /etc/service/syslog-ng
cp /build/runit/syslog-ng /etc/service/syslog-ng/run
chmod +x /etc/service/syslog-ng/run
mkdir -p /var/lib/syslog-ng
mkdir -p /etc/default
cp /build/config/syslog_ng_default /etc/default/syslog-ng
touch /var/log/syslog
chmod u=rw,g=r,o= /var/log/syslog
cp /build/config/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

## Install syslog to "docker logs" forwarder.
mkdir /etc/service/syslog-forwarder
cp /build/runit/syslog-forwarder /etc/service/syslog-forwarder/run
chmod +x /etc/service/syslog-forwarder/run

## Install logrotate.
apk --no-cache add logrotate
cp /build/config/logrotate_syslogng /etc/logrotate.d/syslog-ng

## Install cron daemon.
mkdir /etc/service/cron
chmod 600 /etc/crontabs
cp /build/runit/cron /etc/service/cron/run
chmod +x /etc/service/cron/run

## Remove useless cron entries.
# Checks for lost+found and scans for mtab.
rm -f /etc/cron.daily/standard
rm -f /etc/cron.daily/password
rm -f /etc/cron.weekly/fstrim

## Often used tools.
apk --no-cache add curl psmisc

#cleanup
rm -rf /build
rm -rf /tmp/* /var/tmp/*
