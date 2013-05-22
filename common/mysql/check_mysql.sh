#!/bin/bash
. ../source_all

set_loglevel DEBUG
mysql_drop_db amnontest
mysql_add_db amnontest amnontestuser asdasdasd
if mysql_get_db_users amnontest; then
	for u in $REPLY; do
		echo USER $u
	done
fi
mysql_run_sql_from_url amnontest http://bart.flowsoft.co.il/test.sql
#mysql_run_sql_from_url amnontest file:///var/www/bart/test.sql 
mysql_load_csv_from_url amnontest file:///var/www/bart/test.csv id,name
mysql_drop_db amnontest
