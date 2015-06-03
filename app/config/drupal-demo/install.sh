#!/bin/bash

## install.sh -- Create config files and databases; fill the databases

###############################################################################
## Create virtual-host and databases

amp_install

###############################################################################
## Setup Drupal (config files, database tables)

drupal_install

###############################################################################
## Setup CiviCRM (config files, database tables)

DRUPAL_SITE_DIR=$(_drupal_multisite_dir "$CMS_URL" "$SITE_ID")
CIVI_DOMAIN_NAME="Demonstrators Anonymous"
CIVI_DOMAIN_EMAIL="\"Demonstrators Anonymous\" <info@example.org>"
CIVI_CORE="${WEB_ROOT}/sites/all/modules/civicrm"
CIVI_SETTINGS="${WEB_ROOT}/sites/${DRUPAL_SITE_DIR}/civicrm.settings.php"
CIVI_FILES="${WEB_ROOT}/sites/${DRUPAL_SITE_DIR}/files/civicrm"
CIVI_TEMPLATEC="${CIVI_FILES}/templates_c"
CIVI_EXT_DIR="${WEB_ROOT}/sites/${DRUPAL_SITE_DIR}/ext"
CIVI_EXT_URL="${CMS_URL}/sites/${DRUPAL_SITE_DIR}/ext"
CIVI_UF="Drupal"

civicrm_install

###############################################################################
## Extra configuration
pushd "${WEB_ROOT}/sites/${DRUPAL_SITE_DIR}" >> /dev/null

  drush -y updatedb
  drush -y en civicrm toolbar locale garland login_destination userprotect
  ## disable annoying/unneeded modules
  drush -y dis overlay

  ## Setup CiviCRM
#x  echo '{"enable_components":["CiviEvent","CiviContribute","CiviMember","CiviMail","CiviReport","CiviPledge","CiviCase","CiviCampaign"]}' \
#x    | drush cvapi setting.create --in=json
#x  drush cvapi setting.create versionCheck=0 debug=1
#x  drush cvapi MailSettings.create id=1 is_default=1 domain=example.org debug=1

  ## Setup theme
  #above# drush -y en garland
  export SITE_CONFIG_DIR
  drush -y -u "$ADMIN_USER" scr "$SITE_CONFIG_DIR/install-theme.php"

  ## Based on the block info, CRM_Core_Block::CREATE_NEW and CRM_Core_Block::ADD should be enabled by default, but they aren't.
  ## "drush -y cc all" and "drush -y cc block" do *NOT* solve the problem. But this does:
  drush php-eval -u "$ADMIN_USER" 'module_load_include("inc","block","block.admin"); block_admin_display();'

  ## Setup welcome page
#x  drush -y scr "$SITE_CONFIG_DIR/install-welcome.php"
#x  drush -y vset site_frontpage "welcome"

  ## Setup login_destination
  #above# drush -y en login_destination
#x  drush -y scr "$SITE_CONFIG_DIR/install-login-destination.php"

  ## Setup userprotect
  #above# drush -y en userprotect
#x  drush scr "$PRJDIR/src/drush/perm.php" <<EOPERM
#x    role "authenticated user"
#x    remove "change own e-mail"
#x    remove "change own openid"
#x    remove "change own password"
#xEOPERM

  ## Setup demo user
#x  drush -y en civicrm_webtest
#x  drush -y user-create --password="$DEMO_PASS" --mail="$DEMO_EMAIL" "$DEMO_USER"
#x  drush -y user-add-role civicrm_webtest_user "$DEMO_USER"
#x  # In Garland, CiviCRM's toolbar looks messy unless you also activate Drupal's "toolbar", so grant "access toolbar"
#x  # We've activated more components than typical web-test baseline, so grant rights to those components.
#x  drush scr "$PRJDIR/src/drush/perm.php" <<EOPERM
#x    role 'civicrm_webtest_user'
#x    add 'access toolbar'
#x    add 'administer CiviCase'
#x    add 'access all cases and activities'
#x    add 'access my cases and activities'
#x    add 'add cases'
#x    add 'delete in CiviCase'
#x    add 'administer CiviCampaign'
#x    add 'manage campaign'
#x    add 'reserve campaign contacts'
#x    add 'release campaign contacts'
#x    add 'interview campaign contacts'
#x    add 'gotv campaign contacts'
#x    add 'sign CiviCRM Petition'
#xEOPERM

  ## Setup CiviVolunteer
#x  drush -y cvapi extension.install key=org.civicrm.volunteer debug=1
#x  drush scr "$PRJDIR/src/drush/perm.php" <<EOPERM
#x    role 'anonymous user'
#x    role 'authenticated user'
#x    add 'register to volunteer'
#xEOPERM

#x  drush -y -u "$ADMIN_USER" cvapi extension.install key=eu.tttp.civisualize debug=1
#x  drush -y -u "$ADMIN_USER" cvapi extension.install key=org.civicrm.module.cividiscount debug=1

  ## Setup CiviCRM dashboards
#x  INSTALL_DASHBOARD_USERS="$ADMIN_USER;$DEMO_USER" drush scr "$SITE_CONFIG_DIR/install-dashboard.php"

popd >> /dev/null
