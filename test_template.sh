#!/bin/bash
export MYSQL_HOST="testhost"
export MYSQL_DB="test_db"
export MYSQL_USER="test_user"
export MYSQL_PASS="test_pass"

/work/gamescale/bm3.sh -a create -c gamescale -b conancasino.com
