#!/bin/bash
drush pmu -y ldap ldap_quer ldap_help ldap_servers
composer remove drupal/console drupal/module_missing_message_fixer drupal/backup_migrate drupal/core drupal-composer/drupal-scaffold --no-update
composer require drupal/admin_toolbar:^2.5 drupal/ctools:^3.7 drupal/imce:^2.4 drupal/ldap_servers:^4.3 drupal/ldap:^4.3 drupal/ldap_query:^4.3 drupal/devel:^4.0  drush/drush:^10.0.0 drupal/core-recommended:^9.0.0 --no-update
composer remove --dev webflo/drupal-core-require-dev --no-update
composer update
