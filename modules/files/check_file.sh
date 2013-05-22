#!/bin/bash
MYSQL_PASS_FILE=/tmp/test
. ../../../common/source_all
. ../source_all
save_mysql_credentials dbname amnon asdasd
save_mysql_credentials dbname amnon asdasd1

cat /tmp/test
