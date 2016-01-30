#!/bin/bash

STATE_DIR=/opt/state
AUTH_STATUS_FILE=${STATE_DIR}/setupauth.status

mkdir -p ${STATE_DIR}

if [ -f ${AUTH_STATUS_FILE} ]; then
    exit 0
fi

if [ -n "${RETHINKDB_AUTH_KEY}" ]; then

    # Start rethinkdb for setting up the authentication
    echo "Starting rethinkdb"
    PIDFILE=/tmp/rethinkdb.pid
    /usr/bin/rethinkdb --bind 127.0.0.1 --pid-file ${PIDFILE} --daemon
    sleep 10

    echo "Setting up authentication key"
    echo ${RETHINKDB_AUTH_KEY} > ${STATE_DIR}/rethinkdb-driver-key.txt
    RETHINKDB_AUTH_KEY=${RETHINKDB_AUTH_KEY} python3 /opt/setupauth.py

    echo "Stoping rethinkdb"
    kill $(cat ${PIDFILE})
fi

echo "done" >> ${AUTH_STATUS_FILE}

/usr/bin/rethinkdb $@
