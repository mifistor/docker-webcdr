#!/bin/sh

APP_HOME="/opt/webcdr-master";

cat >> ${APP_HOME}/config.ini <<EOF
;base timezone, valid values:
;  - UTC offset: +0100, -0500
;  - time zone: UTC, US/Pacific, Europe/Brussels
tz = ${TZ:-"Europe/Moscow"}

; database connection settings
[db]
client = ${DB_CLIENTE:-"mysql"}

[db.connection]
host = ${DB_CONNECTION_HOST:-"localhost"}
user = ${DB_CONNECTION_USER:-"root"}
password = ${DB_CONNECTION_PASSWORD:-""}
database = ${DB_CONNECTION_DATABASE:-"asteriskcdrdb"}
charset = ${DB_CONNECTION_CHARSET:-"utf8"}

; cdr table name in the database
[cdr]
table = ${CDR_TABLE:-"cdr"}
; idAttribute = id  ; primary key in cdr table, default is "id"

; web session storage parameters
[session]
key = ${SESSION_KEY:-"123hjhfds7&&&kjfh&&&788"}

[web]
; urlPrefix = ; empty by default, set if running webcdr behind a proxying web server like nginx

[recordings]
pattern = /var/spool/asterisk/monitor/%YYYY%/%MM%/%DD%/*%uniqueid%.wav

[auth.ad]
domain = ${AUTH_AD_DOMAIN:-"example"}

[auth.ad.connection]
url = ${AUTH_AD_CONNECTION_URL:-"ldap://server.ip.address"}
baseDN = ${AUTH_AD_CONNECTION_BASEDN:-"dc=example,dc=org"}
username = ${AUTH_AD_CONNECTION_USERNAME:-"cdruser@example.org"}
password = ${AUTH_AD_CONNECTION_PASSWORD:-"cdruser_ad_password"}

EOF

function _start() {

    [ -d  ${APP_HOME} ] && {

        local SQLFILE="${APP_HOME}/install/db.sql";

        [ -f ${SQLFILE} ] && {
            set -xv;
            mysql ${DB_CONNECTION_DATABASE} -u${DB_CONNECTION_USER} -p${DB_CONNECTION_PASSWORD} -h${DB_CONNECTION_HOST} < $SQLFILE && \
            mv ${SQLFILE} ${SQLFILE//.sql/}.$(date -I).sql;
            set +xv;
        }

        cd ${APP_HOME} && {
            cat config.ini 

            echo ":: open for the business !";
            node ./server.js
        }
    }
}

function main() {

    [ ! -z "$@" ] && { 
        ${@}
        return $?
    }

    [ -z "${DB_CONNECTION_HOST}" ] && return 1;

    local i=0
    while [ $i -lt 30 ]; do
        i=$((i+1));
        nc -zv ${DB_CONNECTION_HOST} 3306 && {
            _start;
        }
        sleep 20;
        echo ":: waiting db in ${DB_CONNECTION_HOST}/${DB_CONNECTION_DATABASE} retry ${i}...";
    done
}

main $@;