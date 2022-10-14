#!/bin/bash
drush sql-query "UPDATE users_field_data SET ldap_user_current_dn=NULL,ldap_user_last_checked=NULL,ldap_user_ldap_exclude=NULL;"
drush pmu ldap_help ldap_user ldap_query ldap_authorization ldap_authentication ldap backup_migrate module_missing_message_fixer
composer remove drupal/backup_migrate drupal/ldap drupal/module_missing_message_fixer --no-update
composer require drupal/admin_toolbar:^2.5 drupal/imce:^2.4 --no-update
composer update
drush updatedb --entity-updates -y
drush updb -y
composer remove --dev webflo/drupal-core-require-dev --no-update
composer remove drupal/ldap drupal/devel drupal/console drupal/core webflo/drupal-finder drupal-composer/drupal-scaffold --no-update
composer require drupal/ldap cweagans/composer-patches drupal/core-recommended:^9 drupal/module_missing_message_fixer drush/drush:^10.0.0 drupal/backup_migrate drupal/core-composer-scaffold:^9 drupal/core-project-message:^9 --update-with-dependencies --no-update
composer update
composer require drupal/easy_install 'drupal/devel_entity_updates:^3' drupal/admin_toolbar:^3 drupal/diff:^1.1 drupal/google_analytics
composer update

#Added some fixes to entity missing
drush en devel_entity_updates -y
drush entity-updates -y
drush php-eval "\Drupal::keyValue('system.schema')->delete('google_analytics');"
drush sql-query "delete config where name = 'google_analytics.settings';"
drush en google_analytics -y

drush updatedb-status

patch -u composer.json -i composer_redirect.patch
composer install
drush updatedb --entity-updates -y
drush updb -y
ldap_address_no_ldaps=$(echo "$ldap_address"  | sed -r 's/ldaps:\/\///g')
drush pm-enable ldap_authentication ldap_servers ldap_user -y
drush cset ldap_servers.server.nci address $ldap_address_no_ldaps -y
drush cset ldap_servers.server.nci port $ldap_port -y
drush cset ldap_servers.server.nci encryption ssl -y
drush cset ldap_authentication.settings sids.nci nci -y
drush cset ldap_authentication.settings skipAdministrators 0 -y
drush updb -y
drush updatedb --entity-updates -y
drush cr
