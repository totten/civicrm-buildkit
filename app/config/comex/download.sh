#!/bin/bash

## download.sh -- Download CiviCRM

###############################################################################

git_cache_setup "https://github.com/civicrm/civicrm-upgrade-manager.git"              "$CACHE_DIR/civicrm/civicrm-upgrade-manager.git"
git_cache_setup	"https://lab.civicrm.org/infra/comex"					"$CACHE_DIR/infra/comex.git"

mkdir "$WEB_ROOT"
pushd "$WEB_ROOT" >> /dev/null
  git clone "$CACHE_DIR/infra/comex.git" .
  composer install --no-scripts
popd >> /dev/null
