#!/bin/bash

display_help() {
	cat <<-EOF >&2
		Usage: $0 [option...]

		  -c file                    Read extra default options from the given file.
		  -?                         Display this help and exit.
		  -d database                Databasename to import to.
		  -f feed                    Directory with unzipped GTFS-Feed.
		  -h hostname                Connect to host.
		  -u username                User for login if not current user.
		  -p password                Password to use when connecting to server.
		  -t                         Truncate tables befor loading.
		  -w                         Show warnings.

	EOF
}

clean_up () {
	ARG=$?

	[ "${TEMPFILE}" != "" ] && test -f ${TEMPFILE} && rm ${TEMPFILE}
	[ "${AUTO_CREDFILE}" = "Y" ] && [ "${CREDFILE}" != "" ] && test -f ${CREDFILE} && rm ${CREDFILE}

	if [ ${ARG} -eq 0 ]; then
		echo "EXIT(${ARG})" 
	else
		echo "EXIT(${ARG})" >&2
	fi

	exit $ARG
}
trap clean_up EXIT

TRUNCATE="N"
SHOW_WARNINGS="N"
AUTO_CREDFILE="Y"
TABLES="agency calendar calendar_dates fare_attributes fare_rules frequencies routes shapes stop_times stops transfers trips"
MYSQL_ARGS="--local-infile=1 -vv"

while getopts ":h:u:p:d:f:twc:" opt; do
	case $opt in
		h)
			MYSQL_HOST=${OPTARG}
			;;
		u)
			MYSQL_USER=${OPTARG}
			;;
		p)
			MYSQL_PWD=${OPTARG}
			;;
		d)
			MYSQL_DB=${OPTARG}
			;;
		f)
			FEED_DIR=${OPTARG}
			;;
		t)
			TRUNCATE="Y"
			;;
		w)
			SHOW_WARNINGS="Y"
			MYSQL_ARGS="${MYSQL_ARGS} --show-warnings"
			;;
		c)
			CREDFILE=${OPTARG}
			AUTO_CREDFILE="N"
			;;
		\?)
			[ "${OPTARG}" != "?" ] && echo "Invalid option: -${OPTARG}" >&2
			display_help
			exit 1
			;;
		:)
			echo "Option -${OPTARG} requires an argument." >&2
			exit 1
			;;
	esac
done

if [ "${MYSQL_DB}" == "" ]; then
	echo "Missing Option: -d database" >&2
	display_help
	exit 1
fi

if [ "${FEED_DIR}" == "" ]; then
	echo "Missing Option: -f feed" >&2
	display_help
	exit 1
fi


if [ "${AUTO_CREDFILE}" = "Y" ]; then
	CREDFILE=$(mktemp)

	cat <<-EOF > ${CREDFILE}
	[client]
	host = ${MYSQL_HOST}
	user = ${MYSQL_USER}
	password = ${MYSQL_PWD}
	EOF
fi

if [ "${TRUNCATE}" = "Y" ]; then
	echo "All tables will truncated bevor loading."
fi

for TABLE in $TABLES; do
	FILE=${FEED_DIR}/${TABLE}.txt

	if [ -f ${FILE} ]; then
		TEMPFILE=$(mktemp)
		LINES=$(wc -l ${FILE} | awk '{ print $1 }')
		COLUMNS=$(head -n 1 ${FILE})
		if [ "${TRUNCATE}" = "Y" ]; then
			TRUNCATE_SQL="TRUNCATE TABLE ${TABLE};"
		fi

		echo "Start loading file ${TABLE}.txt with ${LINES} lines."

		mysql --defaults-extra-file=${CREDFILE} ${MYSQL_ARGS} ${MYSQL_DB} <<-EOF > ${TEMPFILE}
			${TRUNCATE_SQL}
			LOAD DATA LOCAL INFILE '${FILE}'
			INTO TABLE ${TABLE} 
			FIELDS TERMINATED BY ',' 
			OPTIONALLY ENCLOSED BY '"' 
			IGNORE 1 LINES
			(
				${COLUMNS}
			);
		EOF
		RC=$?

		if [ "${SHOW_WARNINGS}" = "Y" ]; then
			grep "Warning " ${TEMPFILE} >&2
		fi
		grep "Records" ${TEMPFILE}

		if [ $RC -eq 0 ]; then
			echo "Loading file ${TABLE}.txt finished."
		else
			echo "Loading file ${TABLE}.txt failed." >&2
			exit 2
		fi

		rm ${TEMPFILE}
	else
		echo "Ignoring missing file ${TABLE}.txt." >&2
	fi
	echo ""
done

if [ "${AUTO_CREDFILE}" = "Y" ]; then
	rm ${CREDFILE}
fi
