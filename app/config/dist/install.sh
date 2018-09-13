#!/bin/bash

## install.sh -- Create config files and databases; fill the databases

CMS_ROOT="$WEB_ROOT/web"

###############################################################################
## Create virtual-host and databases

function dist_install() {
  echo "[[Setup MySQL and HTTP for CMS]]"
  cvutil_assertvars _amp_install_cms CMS_ROOT SITE_NAME SITE_ID TMPDIR
  local amp_vars_file_path=$(mktemp.php ampvar)
  local amp_name="cms$SITE_ID"
  [ "$SITE_ID" == "default" ] && amp_name=cms

  amp create -f --root="$CMS_ROOT" --name="$amp_name" --prefix=CMS_ --url="$CMS_URL" --output-file="$amp_vars_file_path" --skip-db
  source "$amp_vars_file_path"
  rm -f "$amp_vars_file_path"

  CMS_DB_DSN='mysql://fake:fake127.0.0.1:3333/fake?new_link=true'
  CMS_DB_USER='fake'
  CMS_DB_PASS='fake'
  CMS_DB_HOST='127.0.0.1'
  CMS_DB_PORT='3333'
  CMS_DB_NAME='fake'
  CMS_DB_ARGS='--defaults-file='\''fake'\'' fake'

  SNAPSHOT_SKIP=1
}
dist_install

###############################################################################
cvutil_mkdir "$WEB_ROOT/out" "$WEB_ROOT/out/gen" "$WEB_ROOT/out/tmp" "$WEB_ROOT/out/tar" "$WEB_ROOT/out/config"

cat > "$WEB_ROOT/src/distmaker/distmaker.conf" <<EODIST
#!/bin/bash
[ -z "\$DM_SOURCEDIR" ]   && DM_SOURCEDIR=$WEB_ROOT/src
[ -z "\$DM_GENFILESDIR" ] && DM_GENFILESDIR=$WEB_ROOT/out/gen
[ -z "\$DM_TMPDIR" ]      && DM_TMPDIR=$WEB_ROOT/out/tmp
[ -z "\$DM_TARGETDIR" ]   && DM_TARGETDIR=$WEB_ROOT/out/tar
[ -z "\$DM_VERSION" ]     && DM_VERSION=\$( php -r '\$x=simplexml_load_file("../xml/version.xml"); echo \$x->version_no;' )
## distmaker.conf gets loaded multiple times, but we only want suffix applied once
DM_VERSION=\${DM_VERSION}\${DM_VERSION_SUFFIX}
export DM_VERSION_SUFFIX=

DM_PHP=php
DM_RSYNC=rsync
DM_ZIP=zip

# DM_VERSION= <Set this to whatever the version number should be>

## Git banch/tag name
[ -z "\$DM_REF_CORE" ] && DM_REF_CORE=$CIVI_VERSION

DM_REF_DIRNAME=\$(dirname \$DM_REF_CORE)/
if [ "\$DM_REF_DIRNAME" == "./" ]; then
  DM_REF_DIRNAME=
fi
DM_REF_BASENAME=\$(basename \$DM_REF_CORE)

DM_REF_BACKDROP=\${DM_REF_DIRNAME}1.x-\${DM_REF_BASENAME}
DM_REF_DRUPAL=\${DM_REF_DIRNAME}7.x-\${DM_REF_BASENAME}
DM_REF_DRUPAL6=\${DM_REF_DIRNAME}6.x-\${DM_REF_BASENAME}
DM_REF_JOOMLA=\${DM_REF_DIRNAME}\${DM_REF_BASENAME}
DM_REF_WORDPRESS=\${DM_REF_DIRNAME}\${DM_REF_BASENAME}
DM_REF_PACKAGES=\${DM_REF_DIRNAME}\${DM_REF_BASENAME}

EODIST

# create a minimal civicrm.settings.php file; needed for joomla's xml-generation script
cat > "$WEB_ROOT/out/config/civicrm.settings.php" << EOSETTING
<?php
define('CIVICRM_GETTEXT_RESOURCEDIR', '$WEB_ROOT/src/l10n/');
define('CIVICRM_UF', 'Drupal');
global \$civicrm_root;
\$civicrm_root = '$WEB_ROOT/src';
?>
EOSETTING
echo "<?php define('CIVICRM_CONFDIR', '$WEB_ROOT/out/config'); ?>" > "$WEB_ROOT/src/settings_location.php"
