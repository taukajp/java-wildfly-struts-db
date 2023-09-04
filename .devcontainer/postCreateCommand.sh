#!/usr/bin/env bash

set -e

SERVERS_DIR=/home/vscode/.rsp/redhat-server-connector/runtimes/installations
WILDFLY_VER=23.0.2.Final
CONFIG_FILE=${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/standalone.xml

# Add Driver & Datasource
! grep -q -E 'postgrs' ${CONFIG_FILE} \
  && sed -i -e '/driver name="h2"/e cat .devcontainer/postgres/driver.part' -e '/jndi-name="java:jboss\/datasources\/ExampleDS"/e cat .devcontainer/postgres/datasource.part' ${CONFIG_FILE}

exit 0
