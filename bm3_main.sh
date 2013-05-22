#!/bin/bash
# Load common modules
. `dirname $0`/common/source_all
# Load BM3 modules
. `dirname $0`/modules/source_all

# Load main global settings file
. `dirname $0`/conf/bm3.conf

# Set the templates conf dir
TEMPLATES_CONFDIR=`dirname $0`/conf/templates
CONFDIR=`dirname $0`/conf

set_loglevel DEBUG


function check_global_settings() {
	if [ -z "$SVN_ROOT" ]; then
		log ERROR SVN_ROOT not set in global settings file
		exit 1
	fi
}

function usage() {
	echo "Usage:"
	echo
	echo    "`basename $0` -a <action> [-c <component>] -b <brand> [ -t type -n id ] [-e env]"
	echo    "              [-s] [-d distname]"
	echo
	echo    "     action: create - create a component"
	echo    "             update - update a component"
	echo    "      brand: Which brand to use"
	echo -n "             "
	if get_brands_list; then
		for brand in $REPLY; do
			echo -n "$brand "
		done
		echo
	else
		log ERROR "Unable to get brands list"
	fi
	echo    "  component: Which component to perform the action on. If not specified then all."
	echo -n "             "
	if get_components_list; then
		for comp in $REPLY; do
			echo -n "$comp "
		done
		echo
	else
		log ERROR "Unable to get component list"
	fi
	echo    "       type: Either tag or branch"
	echo    "         id: The branch / tag id name"
	echo    "        env: Environment to use (default int)"
	echo	"         -s: In case of the wallet component, use SNAPSHOT"
	echo	"   distname: Use this instead of the default directory name"
	exit 1
}

# First, check that we have everthing we need
check_global_settings

BM_ENV="int"
WALLET_SNAPSHOT=""
BM_COMP=""
# Parse the arguments
while getopts a:c:b:t:n:e:s opt; do
	case $opt in
		a)
			BM_ACTION=$OPTARG
			;;
		n)	BM_TAG=$OPTARG
			;;
		t)	BM_TAG_OR_BRANCH=$OPTARG
			;;
		b)	BRAND_DOMAIN_NAME=$OPTARG
			;;
		c)	BM_COMP=$OPTARG
			;;
		e)	BM_ENV=$OPTARG
			;;
		s)	WALLET_SNAPSHOT="y"
			;;
		d)	DISTRIBUTION_NAME=$OPTARG
			;;
		?)	usage
			;;
	esac
done

if [ -z "$BM_ACTION" ]; then
	echo ERROR: Action required
	usage
fi
#if [ -z "$BM_COMP" ]; then
#	echo ERROR: Component required
#	usage
#fi
if [ -z "$BRAND_DOMAIN_NAME" ]; then
	echo ERROR: Brand required
	usage
fi

if [ -z "$BM_TAG" -a ! -z "$BM_TAG_OR_BRANCH" ]; then
	echo ERROR: type specified but id was not
	usage
fi
if [ ! -z "$BM_TAG" -a -z "$BM_TAG_OR_BRANCH" ]; then
	echo ERROR: id specified but type was not
	usage
fi

if [ ! -z "$BM_TAG_OR_BRANCH" -a "$BM_TAG_OR_BRANCH" != "tag" -a "$BM_TAG_OR_BRANCH" != "branch" ]; then
	echo ERROR: type must be either tag or branch
	usage
fi

if [ "$BM_COMP" != "wallet" -a "$BM_COMP" != "" -a ! -z "$WALLET_SNAPSHOT" ]; then
	echo ERROR: Snapshot is only relevant to the wallet component
	usage
fi

if [ "$BM_COMP" == "wallet" -o "$BM_COMP" == "" ]; then
	if [ -z "$BM_TAG" ]; then
		echo ERROR: -t is required for wallet component for version
		usage
	fi
fi

if [ "$BM_COMP" == "wallet"  -o "$BM_COMP" == "" ]; then
	if [ -z "$WALLET_SNAPSHOT" ]; then
<<<<<<< HEAD
		NEXUS_URL="${NEXUS_SERVER}/nexus/content/repositories/releases/gs1/wallet/${BM_TAG}/wallet-${BM_TAG}.war"
=======
		NEXUS_URL="${NEXUS_SERVER}/nexus/service/local/repositories/releases/content/gs1/wallet/${BM_TAG}/wallet-${BM_TAG}.war"
>>>>>>> 8212b89d75bc4ef2e58ccaf3364954da8883d4de
	else
		NEXUS_URL="${NEXUS_SERVER}/nexus/service/local/artifact/maven/redirect?r=snapshots&g=gs1&a=wallet&v=${BM_TAG}&p=war"
	fi
fi



# TODO: Check if the env is OK
BM_ENV_WITH_DOT="${BM_ENV}."

# Load the brand data

check_files_exist `dirname $0`/conf/brands/$BRAND_DOMAIN_NAME
if [ $? -ne 0 ]; then
	log FATAL Brands configuration does not exist
	exit 1
fi
. `dirname $0`/conf/brands/$BRAND_DOMAIN_NAME
if [ -z "$BRAND_NAME" ]; then
	log ERROR Brand configuration problem - no BRAND_NAME
	exit 1
fi
if [ -z "$READABLE_BRAND_NAME" ]; then
	log ERROR Brand configuration problem - no READABLE_BRAND_NAME
	exit 1
fi


BM_ACTION=`echo $BM_ACTION | tr '[:upper:]' '[:lower:]'`
#if [[ $BM_ACTION != "create" && $BM_ACTION != "update" ]]; then
#	echo ERROR: Invalid action
#	usage
#fi



if [ -z "$BM_TAG" ]; then
	SVN_TYPE="trunk"
	CORE_OR_TAG="core"
	NUMERIC_TAG=""
	NUMERIC_TAG_WITH_US=""
	NUMERIC_TAG_WITH_DOT=""
	NUMERIC_TAG_PREFIX_US=""
else
	if [ "$BM_TAG_OR_BRANCH" == "branch" ]; then
#		SVN_TYPE="branches/$BM_TAG"
		SVN_TYPE="branches"
	else
#		SVN_TYPE="tags/$BM_TAG"
		SVN_TYPE="tags"
	fi
	CORE_OR_TAG=`echo $BM_TAG | tr -d "." | tr -d "_"`
	NUMERIC_TAG=$CORE_OR_TAG
	NUMERIC_TAG_WITH_US=${NUMERIC_TAG}_
	NUMERIC_TAG_PREFIX_US=_${NUMERIC_TAG}
	NUMERIC_TAG_WITH_DOT=${NUMERIC_TAG}.
fi

if  [ -z "$BM_TAG" ]; then
        SVN_TYPE_FULL="$SVN_TYPE"
else
        SVN_TYPE_FULL="$SVN_TYPE/$BM_TAG"
fi


SVN_TYPE_NAME=$BM_TAG
SVN_TYPE_NAME_CLEAN=$NUMERIC_TAG
SVN_TYPE_NAME_SUFFIX_DOT=$NUMERIC_TAG_WITH_DOT
SVN_TYPE_NAME_SUFFIX_US=$NUMERIC_TAG_WITH_US
# This is for compatability
SVN_TYPE_NAME_PREFIX_US=$NUMERIC_TAG_WITH_US
SVN_TYPE_NAME_PREFIX_DOT=$NUMERIC_TAG_WITH_DOT



if [ `domainname` != "(none)" ]; then
	FULL_HOSTNAME=`hostname`.`domainname`
else
	FULL_HOSTNAME=`hostname`
fi

SHORT_HOSTNAME=`hostname | cut -d "." -f1`


LOCAL_IP=`ifconfig eth0 | grep "inet " | cut -d":" -f2 | cut -d" " -f1`
if [ $? -ne 0 ]; then
	log FATAL Failed to get local ip
	exit 1
fi


if [ "$BM_ENV" == "prod" ]; then
	HOSTNAME_IF_PROD="$FULL_HOSTNAME"
else
	HOSTNAME_IF_PROD=""
fi

WWW_BRAND_DIR=$WWW_ROOT/$BRAND_DOMAIN_NAME

if [ "$DISTRIBUTION_NAME" == "" ]; then
	WWW_DISTRIBUTION_DIR="$WWW_ROOT/${BRAND_NAME}_${SVN_TYPE}${NUMERIC_TAG_PREFIX_US}"
else
	WWW_DISTRIBUTION_DIR="$WWW_ROOT/$DISTRIBUTION_NAME"
fi
if [ "$DISTRIBUTION_NAME" == "" ]; then
	JETTY_DISTRIBUTION_DIR="$JETTY_DIR/${BRAND_NAME}_${SVN_TYPE}${NUMERIC_TAG_PREFIX_US}"
else
	JETTY_DISTRIBUTION_DIR="$JETTY_DIR/$DISTRIBUTION_NAME"
fi
log INFO Using $SVN_TYPE as requested version
log INFO Target directory is $WWW_DISTRIBUTION_DIR



LOGEXITONERROR="N"
if [ "$BM_COMP" == "" ]; then
	
	if [ "$BRAND_COMPS" == "" ]; then
		get_components_list
		BM_COMPS=$REPLY
	else
		BM_COMPS="$BRAND_COMPS"
	fi
else
	BM_COMPS=$BM_COMP
fi
for BM_COMP in $BM_COMPS; do

	if [ ! -f $CONFDIR/components/$BM_COMP/$BM_ACTION ]; then
		log ERROR Could not find action file $CONFDIR/components/$BM_COMP/$BM_ACTION
		usage
	fi

	parse_actions_file $CONFDIR/components/$BM_COMP/$BM_ACTION
	if [ $? -ne 0 ]; then
		log ERROR Action failed
		if [ -f $CONFDIR/components/$BM_COMP/$BM_ACTION-error ]; then
			log INFO Running $BM_ACTION-error action
			parse_actions_file $CONFDIR/components/$BM_COMP/$BM_ACTION-error
			if [ $? -ne 0 ]; then
				log ERROR $BM_ACTION-error failed
			fi
		else
			log WARN No $BM_ACTION-error action to run
		fi
	fi
done
