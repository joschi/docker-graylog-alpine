#!/bin/bash -e

JAVA_CMD='/usr/bin/java'
if [ -n "$JAVA_HOME" ]
then
    # try to use $JAVA_HOME
    if [ -x "$JAVA_HOME"/bin/java ]
    then
        JAVA_CMD="$JAVA_HOME"/bin/java
    else
        die "$JAVA_HOME"/bin/java is not executable
    fi
fi

# take variables from environment if set
GRAYLOG_DIR=${GRAYLOG_DIR:=/opt/graylog}
GRAYLOG_SERVER_JAR=${GRAYLOG_SERVER_JAR:=graylog.jar}
GRAYLOG_CONF=${GRAYLOG_CONF:=/opt/graylog/config/graylog.conf}
LOG4J=${LOG4J:=}
DEFAULT_JAVA_OPTS="-Djava.library.path=${GRAYLOG_DIR}/lib/sigar -Xms1g -Xmx1g -XX:NewRatio=1 -server -XX:+ResizeTLAB -XX:+UseConcMarkSweepGC -XX:+CMSConcurrentMTEnabled -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC -XX:-OmitStackTraceInFastThrow"

JAVA_OPTS="${JAVA_OPTS:="$DEFAULT_JAVA_OPTS"} -Dgraylog2.installation_source=docker"

if [ ! -z "${GRAYLOG_NODE_ID}" ]; then
	echo -n "${GRAYLOG_NODE_ID}" > "${GRAYLOG_DIR}/config/node-id"
fi

cd "${GRAYLOG_DIR}"
exec ${JAVA_CMD} ${JAVA_OPTS} ${LOG4J} -jar "${GRAYLOG_SERVER_JAR}" server --configfile "${GRAYLOG_CONF}" --no-pid-file
