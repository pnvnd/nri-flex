#!/bin/sh

cd /home/$1/sqllib

. ./db2profile

db2 connect to $2

db2 -x "SELECT SNAPSHOT_TIMESTAMP, DB_NAME, AGENT_ID, APPL_NAME, AUTHID, TBSP_NAME, TABSCHEMA, TABNAME, TAB_FILE_ID, LOCK_OBJECT_TYPE, LOCK_NAME, LOCK_MODE, LOCK_STATUS, LOCK_ESCALATION, DBPARTITIONNUM, MEMBER FROM SYSIBMADM.LOCKS_HELD"

exit 0