#!/bin/bash
drush sql-query "UPDATE users_field_data SET ldap_user_current_dn=NULL,ldap_user_last_checked=NULL,ldap_user_ldap_exclude=NULL;"
drush pmu ldap_user ldap_help ldap_servers ldap_query ldap_authorization ldap_authentication ldap
composer remove drupal/console
composer remove drupal/core --no-update
composer require drupal/core-recommended:^8.9.0 --no-update
composer update
composer remove drupal/core-composer-scaffold --no-update
composer remove drupal/core-recommended --no-update
composer update
composer remove --dev webflo/drupal-core-require-dev --no-update
composer remove drupal/core-composer-scaffold drupal/module_missing_message_fixer drupal/backup_migrate drupal/ldap --no-update

composer require drupal/devel:^4.0 --no-update
composer require drush/drush:^10.0.0 --no-update
composer require drupal/core-recommended:9.0.0 --no-update
composer update
