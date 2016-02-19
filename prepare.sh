#!/bin/sh
set -e
source /build/buildconfig
set -x

mkdir -p /etc/container_environment

## Enable Ubuntu Universe and Multiverse.
echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk --no-cache upgrade
