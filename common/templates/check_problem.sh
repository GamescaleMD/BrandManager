#!/bin/bash
. ../source_all

set_loglevel DEBUG
#get_template_file_tokens test.tmpl
#echo Got tokens: $REPLY
#VAR1="var1"
define_template_variable VAR1 var1
VAR2="var2"
VAR3="var3"
VAR4="var4"
#VAR5="v a r 5"
define_template_variable VAR5 "v a r 5"
compile_template_file problem.tmpl problem.tst
