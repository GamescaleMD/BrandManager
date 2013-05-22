#!/bin/sh
# BM3 wrapper

BM3_DIR=`dirname $0`

# Check that we are not in development of bm3

which svn > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo ERROR - No svn
	exit 1
fi

if [ -d $BM3_DIR/.svn ]; then
	echo ERROR - There is local .svn dir, existing
	exit 1
fi

#if [ `svn status $BM3_DIR | wc -l` -gt 0 ]; then
#	echo ERROR - There are local changes in the BM3 directory, aborting
#	exit 2
#fi

if [ ! -d $BM3_DIR/brandmgr3 ]; then
	mkdir $BM3_DIR/brandmgr3
	if [ $? -ne 0 ]; then
		echo ERROR - Could not create $BM3_DIR/brandmgr3
		exit 4
	fi
fi

<<<<<<< HEAD
svn --quiet co http://192.168.10.10/svn/brandmgr3 $BM3_DIR/brandmgr3
=======
svn --quiet co http://svn-master/svn/brandmgr3 $BM3_DIR/brandmgr3
>>>>>>> 8212b89d75bc4ef2e58ccaf3364954da8883d4de

if [ $? -ne 0 ]; then
	echo ERROR - Could not get Brand Manager 3
	exit 3
fi
chmod 755 $BM3_DIR/brandmgr3/bm3_main.sh
if [ $? -ne 0 ]; then
	echo ERROR - Could not chown bm3_main.sh
	exit 3
fi
$BM3_DIR/brandmgr3/bm3_main.sh $@
