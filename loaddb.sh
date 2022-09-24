#!/bin/bash
drush sql-cli < database.sql
drush ucrt a
drush urol administrator a
drush upwd a 1234
