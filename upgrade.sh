#!/bin/bash
drush sql-query "UPDATE users_field_data SET ldap_user_current_dn=NULL,ldap_user_last_checked=NULL,ldap_user_ldap_exclude=NULL;"
drush pmu ldap_user ldap_help ldap_servers ldap_query ldap_authorization ldap_authentication ldap
composer remove drupal/backup_migrate drupal/ldap drupal/module_missing_message_fixer --no-update
composer require drupal/admin_toolbar:^2.5 drupal/imce:^2.4 --no-update
composer update
composer remove --dev webflo/drupal-core-require-dev --no-update
composer remove drupal/ldap drupal/devel drupal/console drupal/core webflo/drupal-finder drupal-composer/drupal-scaffold --no-update
composer require drupal/authorization drush/drush:^10.0.0 drupal/backup_migrate drupal/core-composer-scaffold:^9 drupal/core-project-message:^9 --update-with-dependencies --no-update
composer update
drush cr
drush pm:uninstall redirect_after_login
