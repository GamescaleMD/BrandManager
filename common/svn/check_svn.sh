#!/bin/sh
. ../source_all
svn_ls file:///svn/repo/ xml

echo "Reply is $SVN_LS_REPLY"
