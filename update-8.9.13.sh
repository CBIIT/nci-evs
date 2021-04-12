#For EVS
shopt -s expand_aliases
#export PATH=/usr/bin

composer --version

echo "STEP 5: Remove composer and install composer 2.0.12"
yum remove composer -y
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --filename=composer --install-dir=/usr/bin
php -r "unlink('composer-setup.php');"
rm composer-setup.php

composer --version

alias phpm="php -d memory_limit=-1"
#alias composerm="/usr/bin/composer"

echo "**** composer outdated 'drupal/*'  BEFORE"
phpm /usr/bin/composer outdated "drupal/*"


echo "*** CLEAN UP DATABASE"
echo "*** Remove unnecessary TABLES for DB"
echo
SEARCH_TERM="old_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"


SEARCH_TERM="tmp_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

SEARCH_TERM="dd"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

SEARCH_TERM="migrate_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"

echo "*** Install devel_entity_updates"
phpm /usr/bin/composer require drupal/devel_entity_updates
drush pm-enable devel_entity_updates -y

drush entup -y
drush updatedb -y
drush updatedb-status
drush sql-query "show tables"

echo "*** Reinstall Backup and Migrate"
drush pm-uninstall backup_migrate
drush pm-enable backup_migrate -y

echo "*** Uninstall Migrate Plus"
drush pm-uninstall migrate_plus
#Remove the system.schema for migrate_plus
drush php-eval "\Drupal::keyValue('system.schema')->delete('migrate_plus');"

echo "*** Uninstall Migrate"
drush pm-uninstall migrate

#echo "*** Missing Memory Module Fixer"
#drush pm-uninstall module_missing_message_fixer

echo "*** Uninstall ldap_help"
drush pm-uninstall ldap_help

#drush ev "\Drupal::service('config.manager')->uninstall('module', 'migrate_plus');"

echo "*** Reinstall Google Analytics"
drush ev "\Drupal::service('config.manager')->uninstall('module', 'google_analytics');"
drush pm-uninstall google_analytics
drush pm-enable google_analytics -y

echo "*** STEP 1: Add devel_entity_updates"
phpm /usr/bin/composer require drupal/devel_entity_updates
drush pm-enable devel_entity_updates -y

drush entup -y
drush updatedb -y

echo "*** STEP 2: Update to 8.9.x"
phpm /usr/bin/composer require drupal/core:^8.9 webflo/drupal-core-require-dev:^8.9 --update-with-dependencies
drush entup -y
drush updatedb -y

echo "*** STEP 3: Update all modules"
phpm /usr/bin/composer update
drush entup -y
drush updatedb -y
drush cr

echo "*** STEP 4: Update some other modules stuck"
phpm /usr/bin/composer require drupal/devel:^4 drupal/backup_migrate:^5 drupal/imce:^2 drupal/admin_toolbar:^3 drupal/ldap:^4 drupal/ldap_servers:^4
phpm /usr/bin/composer require drupal/bootstrap_barrio:^5.5@beta twbs/bootstrap:^5
drush entup -y
drush updatedb -y
drush cr

# NEW Modules

phpm /usr/bin/composer require drush/drush:^10 drupal/drupalmoduleupgrader drupal/config_filter
drush entup -y
drush updatedb -y
drush cr

phpm /usr/bin/composer require drupal/ldap:^4 drupal/ldap_servers:^4
drush entup -y
drush updatedb -y
drush cr

phpm /usr/bin/composer require drush/drush:^10
drush entup -y
drush updatedb -y
drush cr

echo "*** Get rid of path_alias path_alias issue"
drush ev '$definition_update_manager=\Drupal::entityDefinitionUpdateManager();$definition_update_manager->updateEntityType(\Drupal::entityTypeManager()->getDefinition("path_alias"));'
SEARCH_TERM="tmp_"
echo "SEARCH_TERM = $SEARCH_TERM"
echo "**** EXECUTE THESE COMMANDS AT THE COMMAND LINE"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" echo mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "show tables;" -s |egrep "^$SEARCH_TERM" |xargs -I "@@" mysql --user=$username --password=$password --database=$database --host=$host --port=$port -A -e "DROP TABLE @@"
drush entup -y
drush updatedb -y
drush cr

#echo "*** Uninstall devel_entity_updates"
#drush pm-uninstall devel_entity_updates
echo "**** Install these additional modules"
echo ""
echo "easy_install"
phpm /usr/bin/composer require drupal/easy_install
drush pm-enable easy_install -y

echo
echo "*** Upgrade Complete"
echo "*** STATUS"
echo "*** drush pm-security"
drush pm-security
echo "**** composer outdated 'drupal/*'  AFTER"
phpm /usr/bin/composer outdated "drupal/*"


echo "*** drush updatedb-status"

drush updatedb-status

drush status
/usr/bin/composer --version
drush --version
php -v 
httpd -v 

echo "Upgrade completed:  Check Reports->Available Updates and Reports->Status for info.  Should be all GREEN and no issues on STATUS page."

#phpm /usr/bin/composer remove webflo/drupal-core-require-dev
#drush updatedb -y
#drush ev '$definition_update_manager=\Drupal::entityDefinitionUpdateManager();$definition_update_manager->updateEntityType(\DrupantityTypeManager()->getDefinition("url_alias"));'

