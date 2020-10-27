#!/bin/bash
[ -d "$WEB_ROOT/web" ] && CMS_ROOT="$WEB_ROOT/web"
amp_install

pushd "$WEB_ROOT"
  amp data "data"
  [ -f data/oauth.sqlite ] && rm -f data/oauth.sqlite

  cat > "$WEB_ROOT/data/parameters.json" <<EOJSON
{
  "client_id": "demoapp",
  "client_secret": "demopass",
  "token_route": "grant",
  "authorize_route": "authorize",
  "resource_route": "access",
  "resource_params": {},
  "user_credentials": ["demousername", "demouserpass"],
  "http_options": { "exceptions": false }
}
EOJSON
popd
