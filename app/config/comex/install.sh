#!/bin/bash

## install.sh -- Create config files and databases; fill the databases

CMS_ROOT="$WEB_ROOT/web"

###############################################################################
## Create virtual-host and databases

amp_install

###############################################################################
## Setup config files

#amp datadir "$WEB_ROOT/var" "$WEB_ROOT/var/cache" "$WEB_ROOT/var/logs" "$WEB_ROOT/var/sessions"

pushd "$WEB_ROOT" >> /dev/null
  composer install
#  ./bin/console doctrine:schema:create
popd >> /dev/null
