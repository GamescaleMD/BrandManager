#!/bin/bash
. ../source_all

#check_files_exist test_file.sh adadasd

#get_file_from_url http://bart.flowsoft.co.il/test.sql
#get_file_from_url http://bart.flowsoft.co.il/test.sql test.ttt
#get_file_from_url file:///var/www/bart/test.sql test.ttt
get_file_from_url file:///var/www/bart/test.sql 
echo got $GET_FILE_FROM_URL_REPLY
ls -l $GET_FILE_FROM_URL_REPLY
cat $GET_FILE_FROM_URL_REPLY
delete_file_if_temp $GET_FILE_FROM_URL_REPLY
ls -l $GET_FILE_FROM_URL_REPLY
