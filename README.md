Brand Manager 3
By Gilad Ventura


<<<<<<< HEAD
=======






















>>>>>>> 8212b89d75bc4ef2e58ccaf3364954da8883d4de
1.1 Terminology
Term 
Description
Distribution
A single working casino package with all of its components and databases.
WP
Wordpress
BO
Back office
GS
Game Server
BOUI
Back office user interface
Wallet
Wallet components, based on scala
BM
Brand manager

1.2 Usage
bm3.sh -a <action> -b <brand> 
1.2.1 Available parameters 
-a <action>
create
delete
update
will svn update a specific distribution.
switch
will svn switch a specific distribution to a different svn path.
-b <brand>
cosmikcasino
deuceclub
-c <component> optional – default: all
wp
bo
gs
boui
wallet
-t <type> optional – default: trunk
branch
tag
trunk
-n <type name> optional (dependent on type) – default: trunk
Branch name
Tag name
-d <distribution display name> optional
A custom name the distribution will be represented as
-s optional
Simulate the action with debug data displayed
-l optional
List all available installed distributions, should be used only as a single parameter
-r <revision number> optional
Revision number, used for the update action to update to a specific revision. Wallet component will not be affected by revision number as its not versioned.
-cleanup <bool> optional
Default: true, does the BM should cleanup on failure? 
1.2.2 Usage examples
bm3.sh -a create -b cosmikcasino -t tag -n 116003 –d latestcosmik
will create the cosmikcasino brand, all components,  based on tag 116003 and will be known as latestcosmik.devmachine.cosmikcasino.com
bm3.sh -a create -b cosmikcasino –c wp –d temp
will create the cosmikcasino brand, wp component,  based on trunk and will be known as temp.devmachine.cosmikcasino.com
bm3.sh -a switch -b cosmikcasino –d temp –t tag –n 1.16.0_03
will switch the cosmikcasino distribution custom-named 'temp' to be based on tag 1.16.0_03
bm3.sh -a update -b deuceclub –t tag –n 1.17.0 –r 1265421
will update the deuceclub tag 1.17.0 distribution to revision 1265421
1.3 Routing 
All distributions created should be accessible from every internal machine via Gamescale's DNS server. BM should register every new distribution created into the DNS server and vice versa.
1.3.1 Distributions URL structure
[tag123 / branch123 / trunk / custom distribution display name].[machine name].www.[brand real URL].com
1.4 Source structure
To make sure the BM will stay relevant, it should be modular and scalable. Thus the components actions scripts should be modular and a main brand configuration file should be available.
Generally, to add a new brand / component / action type to the BM, all that will be required is to add a new action script, brand configuration file or a new component folder with its relevant action scripts.
1.4.1 Actions scripts
Actions scripts are files containing a set of actions required to create / delete / update (etc..) a specific component. That means that for every action type for every component a file should be available respectively.
e.g:
wordpress
/create
/delete
/update
…
Backoffice
/create
/delete
/update
…
(other components)
..
1.4.2 Brand configuration file
A configuration file representing a brand in the system, including every brand specific parameter needed as well as enabled components for the brand (some brands might require different components to work)
1.5 General features
1.5.1 Ubuntu based
BM3 should be based on Ubuntu server 10
1.5.2 Backup before update / switch
When updating or switching there is a chance of a failure in the process, which may turn the distribution to be not functional. Thus when BM runs an update script, it should first backup the entire distribution (make a temp copy of everything including DB) so in case of an error restoration can use the copy.
1.5.3 Cleanup on failure 
When creating a distribution BM should know how to remove everything back in case of a failure in the process. It should act as a garbage collector.
1.5.4 Database versioning
When using the "switch" or "update" actions, the distribution database should remain intact with all of it's contents. In order to upgrade the DB scheme to the new  version without damaging the data a new upgrade – downgrade system should be integrated.
Each component which should support DB upgrading / downgrading should consists of a base.sql file which should contain the base scheme and content of the DB. From that point, each change of DB scheme should be done with an upgrade script named up%d.sql and a matching reverse script named down%d.sql . the %d digit represents the DB version, from 2 …. N (from 2 because the base.sql is 1). 
To track a specific distribution DB version a new DB table will be introduced: DBVersionsLog
Name
Type
Id
Int (auto increment)
Version
Int
Date
Datetime

Each 'installed' DB upgrade by the BM should be appended by the BM and the last row is the current DB version. Consider the following example
Id
Version
Date
1
base
2012-9-2 10:10:10
2
2
2012-9-2 10:10:11
3
3
2012-9-2 10:10:12
4
4
2012-9-2 10:10:13

1.5.4.1 Creating
When creating a distribution, BM should run the base.sql file followed by the up%d.sql files ordered while updating the DBVersionsLog table with the newly installed upgrade scripts accordingly.
1.5.4.2 Upgrading
When switching a distribution, BM should not delete the old DB and scripts folder, but instead inspect the DBVersionsLog table and compare the latest DB version installed with the available DB scripts. If there are additional DB scripts which are not installed according to the DBVersionsLog table, an upgrade is needed.
To upgrade, BM should run the new up%d.sql files ordered while updating the DBVersionsLog table with the newly installed upgrade scripts accordingly. At the end of the process BM should delete the old scripts folder.
1.5.4.3 Downgrading
When switching / updating a distribution, BM should not delete the old DB and scripts folder, but instead inspect the DBVersionsLog table and compare the latest DB version installed with the available DB scripts. If the latest DB version upgrade script according to the DBVersionsLog table is not available in the new version, a downgrade is needed.
To downgrade, BM should run the old scripts folder down%d.sql files from the latest to the new scripts folder latest (not included) while deleting the relevant DBVersionsLog rows accordingly. At the end of the process BM should delete the old scripts folder.
In case of a missing downgrade script needed, BM action should fail.
1.6 Tags
Usage: ${TAG_NAME} on script files or %TAG_NAME@ on template files
Tag
Description / Example
BRAND_DOMAIN_NAME
Cosmikcasino.com
READABLE_BRAND_NAME
Cosmic casino
BRAND_NAME
Cosmikcasino
SVN_TYPE
empty(trunk) / tags / branches
SVN_TYPE_NAME
1.16.0_05
SVN_TYPE_NAME_CLEAN
116005
SVN_TYPE_NAME_PREFIX_DOT
116005.
SVN_TYPE_NAME_PREFIX_US
116005_
WWW_ROOT
/var/www
SVN_ROOT
http://svn-master/svn/gs1
APACHE_CONF_DIR
/etc/httpd/conf.d or /etc/apache2
WWW_DISTRIBUTION_DIR
/var/www/[distribution display name / type + type name]
e.g
/var/www/latest_cosmik
/var/www/cosmikcasino_tag_116005
/var/www/cosmikcasino_branch_2486
/var/www/cosmikcasino_trunk
JETTY_ DISTRIBUTION _DIR
the distribution dir inside the jetty apps folder path
e.g
/[JETTY_APPS_PATH]/latest_cosmik
/[JETTY_APPS_PATH]/cosmikcasino_tag_116005
/[JETTY_APPS_PATH]/cosmikcasino_branch_2486
/[JETTY_APPS_PATH]/cosmikcasino_trunk
DISTRIBUTION_NAME
The distribution custom display name or the svn type + the svn type name is missing
e.g
latest_cosmik
cosmikcasino_tag_116005
cosmikcasino_branch_2486
cosmikcasino_trunk

1.7 Actions breakdown
1.7.1 Create
1.7.1.1 Wordpress
1. Install if required
a. Apache
b. Memcache
c. Mysql
2. Create DB
a. Name should be informative, consisting of distribution name and the relevant component type e.g wp\bo\gs\wallet
3. Get Wordpress
a. Wp-config.php and .htaccess should be already inside the wordpress folder
4. Parse wp-config.php
a. wp-config.php should be present in the wordpress framework including the relevant tokens to be parsed to real values by the BM
5. SVN checkout the Wordpress theme
a. From:  ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/themes/${BRAND_NAME}
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/themes/${BRAND_NAME}
6. SVN checkout Wordpress plugin "GS_core"
a. From:  ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_core/${BRAND_NAME}
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core
7. SVN checkout Wordpress plugin "GS_block_ie"
a. From: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_block_ie
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_block_ie
8. SVN checkout Wordpress plugin "GS_ajax"
a. From: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_ajax
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_ajax
9. SVN checkout Wordpress plugin "GS_DC_flash"
a. From: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_DC_flash
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_DC_flash
10. SVN checkout Wordpress plugin "wpml"
a. From: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/sitepress-multilingual-cms
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/sitepress-multilingual-cms
11. SVN checkout Wordpress plugin "w3 total cache"
a. From: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/w3-total-cache
b. To: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/w3-total-cache
c. Copy all files from  ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/w3-total-cache/installation_files into ${WWW_DISTRIBUTION_DIR}/wp/wp-content
12. Import reset.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/reset.sql
13. Import content.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/content.sql
14. Import CSV's into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/*.csv
15. Parse _GS_config.php
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/_GS_config.php
16. Create apache virtual host
a. Should be according to routing requirements
b. Should have a SYSTEM_ENVIRONMENT variable set to dev/qa/stage/prod accordingly
17. Reset memcache

1.7.1.2 Back office
1. Install if required
a. Apache
b. Memcache
c. Mysql
2. Create DB
a. Name should be informative, consisting of distribution name and the relevant component type e.g wp\bo\gs\wallet
3. Get Yii
a. To: ${WWW_DISTRIBUTION_DIR}/yii
4. SVN checkout the BO
a. From:  ${SVN_ROOT}/${SVN_TYPE}/backoffice/
b. To: ${WWW_DISTRIBUTION_DIR}/bo
c. Copy all files from  ${WWW_DISTRIBUTION_DIR}/ bo/protected/config/${BRAND_NAME}/files into ${WWW_DISTRIBUTION_DIR}/ bo/protected/config/
5. Parse main. ${env}.conf
a. From: ${WWW_DISTRIBUTION_DIR}/ bo/protected/config/main. ${env}.conf
6. Import base and upgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/upgrade/up%d.sql
c. Base from: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/base 
7. Import base.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/base
8. Create + Parse cron from txt
a. Should contain the relevant tokens to be parsed to real values by the BM
b. From: ${WWW_DISTRIBUTION_DIR}/bo/cron/cron.txt
9. Create apache virtual host
a. Should be according to routing requirements
b. Should have a SYSTEM_ENVIRONMENT variable set to dev/qa/stage/prod accordingly
10. Set CLI with SYSTEM_ENVIRONMENT global variable
a. variable set to dev/qa/stage/prod accordingly
11. Reset memcache
1.7.1.3 Back office UI
1. Install if required
a. Apache
b. Memcache
2. SVN checkout the BOUI
a. From:  ${SVN_ROOT}/${SVN_TYPE}/BOUI/
b. To: ${WWW_DISTRIBUTION_DIR}/boui
3. Parse main.conf
a. From: ${WWW_DISTRIBUTION_DIR}/boui/protected/config/main.conf
4. Create apache virtual host
a. Should be according to routing requirements
b. Should have a SYSTEM_ENVIRONMENT variable set to dev/qa/stage/prod accordingly
5. Set CLI with SYSTEM_ENVIRONMENT global variable
a. variable set to dev/qa/stage/prod accordingly
6. Reset memcache


1.7.1.4 Game server 
1. Install if required
a. Apache
b. Memcache
c. Mysql
2. Create DB
a. Name should be informative, consisting of distribution name and the relevant component type e.g wp\bo\gs\wallet
3. SVN checkout the games
a. From:  ${SVN_ROOT}/${SVN_TYPE}/games/
b. To: ${WWW_DISTRIBUTION_DIR}/games
4. Parse site.conf.php
a. From: ${WWW_DISTRIBUTION_DIR}/games/site.conf.php
5. Import base and upgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${WWW_DISTRIBUTION_DIR}/games/DB/${BRAND_NAME}/upgrade/up%d.sql
c. Base from: ${WWW_DISTRIBUTION_DIR}/games/DB/${BRAND_NAME}/base 
6. Import base.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/games/DB/${BRAND_NAME}/base
7. Create apache virtual host
a. Should be according to routing requirements
b. Should have a SYSTEM_ENVIRONMENT variable set to dev/qa/stage/prod accordingly
8. Reset memcache

1.7.1.5 Area 51 
1. Install if required
a. Apache
b. Memcache
2. SVN checkout the area51
a. From:  ${SVN_ROOT}/${SVN_TYPE}/games/
b. To: ${WWW_DISTRIBUTION_DIR}/area51
3. Parse site.conf.php
a. From: ${WWW_DISTRIBUTION_DIR}/area51/ site.conf.php
4. Create apache virtual host
a. Should be according to routing requirements
b. Should have a SYSTEM_ENVIRONMENT variable set to dev/qa/stage/prod accordingly
5. Reset memcache

1.7.1.6 Wallet
1. Install if required
a. Jetty
b. Mysql
2. Create DB
a. Name should be informative, consisting of distribution name and the relevant component type e.g wp\bo\gs\wallet
3. Get and extract .war file by required version
a. Version from: ${SVN_ROOT}/${SVN_TYPE}/externals/wallet.txt
b. Should recognize 'latest' as the newest code available
c. BM should download the .war files from a Nexus server
d. BM should know from which nexus url to get wallet .war file according to required version
e. Should be saved and extracted at the Jetty web apps folder as 
4. Import base and upgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${ JETTY _BRAND_DIR}/web_inf/classes/sql/upgrade/up%d.sql
c. Base from: ${ JETTY _BRAND_DIR}/web_inf/classes/sql/base.sql
5. Import create.sql  into DB
a. From: ${JETTY_DISTRIBUTION_DIR}/web_inf/classes/sql/base.sql
6. Parse props.txt
a. From: ${JETTY_DISTRIBUTION_DIR}/web_inf/classes/props/props.txt
7. Create Jetty virtual host
8. Restart Jetty
1.7.2 Update
1.7.2.1 Wordpress
1. SVN update the Wordpress theme
2. SVN update Wordpress plugin "GS_core"
3. SVN update Wordpress plugin "GS_block_ie"
4. SVN update Wordpress plugin "GS_ajax"
5. SVN update Wordpress plugin "GS_DC_flash"
6. SVN update Wordpress plugin "wpml"
7. SVN update Wordpress plugin "w3 total cache"
a. Copy & override all files from  ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/w3-total-cache/installation_files into ${WWW_DISTRIBUTION_DIR}/wp/wp-content
8. Import reset.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/reset.sql
9. Import content.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/content.sql
10. Import CSV's into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/*.csv
11. Parse _GS_config.php
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/_GS_config.php
12. Reset memcache
1.7.2.2 Back office
1. SVN update bo folder
2. Import upgrade/downgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/upgrade/up%d.sql
c. Downgrade from: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/downgrade/down%d.sql
3. Parse main. ${env}.conf
a. From: ${WWW_DISTRIBUTION_DIR}/ bo/protected/config/main. ${env}.conf
4. Update + Parse cron from txt
a. Should contain the relevant tokens to be parsed to real values by the BM
b. From: ${WWW_DISTRIBUTION_DIR}/bo/cron/cron.txt
5. Reset memcache

1.7.2.3 Back office UI
1. SVN update boui folder
2. Parse main.conf
a. From: ${WWW_DISTRIBUTION_DIR}/boui/protected/config/main.conf
3. Reset memcache
1.7.2.4 Game server 
1. SVN update games folder 
2. Parse site.conf.php
a. From: ${WWW_DISTRIBUTION_DIR}/games/site.conf.php
3. Import upgrade/downgrade sql into DB
a. Upgrade from: ${WWW_DISTRIBUTION_DIR}/games/db/${BRAND_NAME}/upgrade/up%d.sql
b. Downgrade from: ${WWW_DISTRIBUTION_DIR}/games/db/${BRAND_NAME}/downgrade/down%d.sql
4. Reset memcache
1.7.2.5 Area 51 
1. SVN update area51 folder
2. Parse site.conf.php
a. From: ${WWW_DISTRIBUTION_DIR}/area51/ site.conf.php
3. Reset memcache
1.7.2.6 Wallet
1. Install if required
a. Jetty
b. Mysql
2. Get and extract .war file by required version
a. Version from: ${SVN_ROOT}/${SVN_TYPE}/externals/wallet.txt
b. Should recognize 'latest' as the newest code available
c. BM should download the .war files from a Nexus server
d. BM should know from which nexus url to get wallet .war file according to required version
e. Should be saved and extracted at the Jetty web apps folder as 
3. Import upgrade/downgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${ JETTY _BRAND_DIR}/web_inf/classes/sql/upgrade/up%d.sql
c. Downgrade from: ${ JETTY _BRAND_DIR}/ web_inf/classes/sql/downgrade/down%d.sql
4. Parse props.txt
a. From: ${ JETTY _BRAND_DIR}/web_inf/classes/props/props.txt
5. Restart Jetty
1.7.3 Switch
1.7.3.1 Wordpress
1. Rename DB
a. Name should be informative, consisting of distribution name and the relevant component type e.g wp\bo\gs\wallet
2. Rename wordpress folder
3. Get new Wp-config.php 
a. Should be clean with all of the relevant tokens intact
4. Parse wp-config.php
a. wp-config.php should be present in the wordpress framework including the relevant tokens to be parsed to real values by the BM
5. SVN switch the Wordpress theme
a. To: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/themes/${BRAND_NAME}
6. SVN switch Wordpress plugin "GS_core"
a. To:  ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_core/${BRAND_NAME}
7. SVN switch Wordpress plugin "GS_block_ie"
a. To: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_block_ie
8. SVN switch Wordpress plugin "GS_ajax"
a. To: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_ajax
9. SVN switch Wordpress plugin "GS_DC_flash"
a. To: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/GS_DC_flash
10. SVN switch Wordpress plugin "wpml"
a. To: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/sitepress-multilingual-cms
11. SVN switch Wordpress plugin "w3 total cache"
a. To: ${SVN_ROOT}/${SVN_TYPE}/wordpress/wp-content/plugins/w3-total-cache
b. Copy all files from  ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/w3-total-cache/installation_files into ${WWW_DISTRIBUTION_DIR}/wp/wp-content
12. Import reset.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/reset.sql
13. Import content.sql into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/content.sql
14. Import CSV's into DB
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/db/*.csv
15. Parse _GS_config.php
a. From: ${WWW_DISTRIBUTION_DIR}/wp/wp-content/plugins/GS_core/_GS_config.php
16. Modify apache virtual host
a. Should be according to routing requirements
b. Should have a SYSTEM_ENVIRONMENT variable set to dev/qa/stage/prod accordingly
17. Reset memcache

1.7.3.2 Back office
1. SVN switch bo folder
a. To:  ${SVN_ROOT}/${SVN_TYPE}/backoffice/
2. Import upgrade/downgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/upgrade/up%d.sql
c. Downgrade from: ${WWW_DISTRIBUTION_DIR}/bo/DB/${BRAND_NAME}/downgrade/down%d.sql
3. Parse main. ${env}.conf
a. From: ${WWW_DISTRIBUTION_DIR}/ bo/protected/config/main. ${env}.conf
4. Update + Parse cron from txt
a. Should contain the relevant tokens to be parsed to real values by the BM
b. From: ${WWW_DISTRIBUTION_DIR}/bo/cron/cron.txt
5. Reset memcache

1.7.3.3 Back office UI
1. SVN switch boui folder
a. To:  ${SVN_ROOT}/${SVN_TYPE}/BOUI/
2. Parse main.conf
a. From: ${WWW_DISTRIBUTION_DIR}/boui/protected/config/main.conf
3. Reset memcache
1.7.3.4 Game server 
1. SVN switch games folder
a. To:  ${SVN_ROOT}/${SVN_TYPE}/games/
2. Parse site.conf.php
a. From: ${WWW_DISTRIBUTION_DIR}/games/site.conf.php
3. Import upgrade/downgrade sql into DB
a. Upgrade from: ${WWW_DISTRIBUTION_DIR}/games/db/${BRAND_NAME}/upgrade/up%d.sql
b. Downgrade from: ${WWW_DISTRIBUTION_DIR}/games/db/${BRAND_NAME}/downgrade/down%d.sql
4. Reset memcache
1.7.3.5 Area 51 
1. SVN switch area51 folder
a. To: ${SVN_ROOT}/${SVN_TYPE}/games/
2. Parse site.conf.php
a. From: ${WWW_DISTRIBUTION_DIR}/area51/ site.conf.php
3. Reset memcache
1.7.3.6 Wallet
1. Install if required
a. Jetty
b. Mysql
2. Rename DB
3. Get and extract .war file by required version
a. Version from: ${SVN_ROOT}/${SVN_TYPE}/externals/wallet.txt
b. Should recognize 'latest' as the newest code available
c. BM should download the .war files from a Nexus server
d. BM should know from which nexus url to get wallet .war file according to required version
e. Should be saved and extracted at the Jetty web apps folder as 
4. Import upgrade/downgrade sql into DB
a. As in "Database versioning" section
b. Upgrade from: ${ JETTY _BRAND_DIR}/web_inf/classes/sql/upgrade/up%d.sql
c. Downgrade from: ${ JETTY _BRAND_DIR}/ web_inf/classes/sql/downgrade/down%d.sql
5. Parse props.txt
a. From: ${ JETTY _BRAND_DIR}/web_inf/classes/props/props.txt
6. Modify Jetty virtual host
7. Restart Jetty
1.7.4 Delete
1.7.4.1 Wordpress
1. Delete DB
2. Delete folder
3. Delete apache virtual host
4. Reset memcache

1.7.4.2 Back office
1. Delete DB
2. Delete Yii
3. Delete folder
4. Delete cron
5. Delete apache virtual host
6. Reset memcache
1.7.4.3 Back office UI
1. Delete folder
2. Reset memcache
1.7.4.4 Game server 
1. Delete DB
2. Delete folder
3. Delete apache virtual host
4. Reset memcache
1.7.4.5 Area 51 
1. Delete folder
2. Delete apache virtual host
3. Reset memcache
1.7.4.6 Wallet
1. Delete DB
2. Delete wallet from Jetty web apps folder
3. Delete Jetty virtual host
<<<<<<< HEAD
4. Restart Jetty
=======
4. Restart Jetty



>>>>>>> 8212b89d75bc4ef2e58ccaf3364954da8883d4de
