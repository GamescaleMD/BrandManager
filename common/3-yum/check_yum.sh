#!/bin/bash
. ../source_all

set_loglevel DEBUG
yum_ensure_package_installed httpd lrzsz
