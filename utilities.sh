#!/bin/sh
set -e
source /build/buildconfig
set -x

## Often used tools.
apk --no-cache add curl psmisc

## This tool runs a command as another user and sets $HOME.
cp /build/bin/setuser /sbin/setuser
chmod 750 /sbin/setuser
