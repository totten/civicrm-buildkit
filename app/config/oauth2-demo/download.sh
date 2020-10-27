#!/bin/bash
git_cache_setup "https://github.com/bshaffer/oauth2-demo-php" "$CACHE_DIR/bshaffer/oauth2-demo-php"
git clone "$CACHE_DIR/bshaffer/oauth2-demo-php" "$WEB_ROOT"
pushd "$WEB_ROOT"
  composer install
  patch -p0 < "$SITE_CONFIG_DIR/patches/100-disable-mcrypt.diff"
popd
