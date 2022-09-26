#!/bin/bash
mysql -u$username -p$password -h$host -P$port -e "drop database evs;"
mysql -u$username -p$password -h$host -P$port -e "create database evs;"
drush sql-cli < database.sql
drush ucrt a
drush urol administrator a
drush upwd a 1234
