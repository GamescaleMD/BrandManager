#!/bin/bash
. ../common/source_all

mysql_drop_db conancasino_v
\rm -R /var/www/conancasino.com/core.games

./bm3.sh -a create -c gamescale -b deuceclub.com -t 1.14.0_08




