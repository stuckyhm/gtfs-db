#!/bin/bash
set -ex

MYSQL_HOST=127.0.0.1
MYSQL_USER=root
MYSQL_PWD=Asdf1234
MYSQL_DB=gtfs
FEED=../../nyc_subway_network/GTFS_nyc_Subway


MYSQL="mysql -vv -h ${MYSQL_HOST} -u ${MYSQL_USER} -p${MYSQL_PWD}"

${MYSQL} -e "DROP DATABASE IF EXISTS ${MYSQL_DB};"
${MYSQL} -e "CREATE DATABASE ${MYSQL_DB};"

${MYSQL} ${MYSQL_DB} < tables_create.sql

./load_feed.sh -h ${MYSQL_HOST} -u ${MYSQL_USER} -p ${MYSQL_PWD} -d ${MYSQL_DB} -f ${FEED} -w

${MYSQL} ${MYSQL_DB} < generate_xtra_dates.sql
${MYSQL} ${MYSQL_DB} < generate_xtra_service_dates.sql
${MYSQL} ${MYSQL_DB} < generate_xtra_trips_extended.sql
${MYSQL} ${MYSQL_DB} < generate_xtra_trip_stop_times.sql

