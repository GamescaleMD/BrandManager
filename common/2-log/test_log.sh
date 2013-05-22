#!/bin/bash

. ../source_all


#set_logfile TEST
#echo -n "Log level is set to "
#print_loglevel 
#echo

# Timestamp testing
log "test default time stamp"
set_timestamp "N"
log "test no time stamp"
set_timestamp "Y"
log "test with time stamp"

set_loglevel INFO
# log level testing
log DEBUG This should not log
set_loglevel DEBUG
log DEBUG This should log
log FATAL This is a FATAL message



set_loglevel INFO
echo -n "Log level is set to "
print_loglevel 
echo

log DEBUG This should NOT log

# Test execute
log -e id
# This should not log
log DEBUG -e id
# This should log
log fatal -e uname

