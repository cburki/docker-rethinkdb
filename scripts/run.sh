#!/bin/bash

STATE_DIR=/opt/state
AUTH_STATUS_FILE=${STATE_DIR}/setupauth.status

mkdir -p ${STATE_DIR}

if [ -f ${AUTH_STATUS_FILE} ]; then
    exit 0
fi

if [ -n "${RETHINKDB_ADMIN_PASSWORD}" ]; then

    # Start rethinkdb for setting up the authentication
    echo "Starting rethinkdb"
    PIDFILE=/tmp/rethinkdb.pid
    /usr/bin/rethinkdb --bind 127.0.0.1 --pid-file ${PIDFILE} --daemon
    sleep 10

    echo "Setting up the admin authentication password"
    echo ${RETHINKDB_ADMIN_PASSWORD} > ${STATE_DIR}/rethinkdb-admin-password.txt
    RETHINKDB_ADMIN_PASSWORD=${RETHINKDB_ADMIN_PASSWORD} python3 /opt/setupauth.py

    echo "Stoping rethinkdb"
    kill $(cat ${PIDFILE})
    sleep 5
fi

echo "done" >> ${AUTH_STATUS_FILE}

exec /usr/local/bin/dumb-init /usr/bin/rethinkdb $@
