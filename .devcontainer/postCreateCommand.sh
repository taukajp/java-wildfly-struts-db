#!/usr/bin/env bash

set -e

SERVERS_DIR=/home/vscode/.rsp/redhat-server-connector/runtimes/installations
WILDFLY_VER=23.0.2.Final
CONFIG_FILE=${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/standalone.xml
MS_DRIVER_VER=8.1.0

# Add Driver & Datasource
! grep -q -E 'postgrs' ${CONFIG_FILE} \
  && sed -i -e '/driver name="h2"/e cat .devcontainer/postgres/driver.part' -e '/jndi-name="java:jboss\/datasources\/ExampleDS"/e cat .devcontainer/postgres/datasource.part' ${CONFIG_FILE}
! grep -q -E 'mysql' ${CONFIG_FILE} \
  && sed -i -e '/driver name="h2"/e cat .devcontainer/mysql/driver.part' -e '/jndi-name="java:jboss\/datasources\/ExampleDS"/e cat .devcontainer/mysql/datasource.part' ${CONFIG_FILE}

test ! -e ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/mysql/main/mysql-connector-j-${MS_DRIVER_VER}.jar \
  && mvn dependency:get -DgroupId=com.mysql -DartifactId=mysql-connector-j -Dversion=${MS_DRIVER_VER} \
  && cp /workspaces/myapp/.m2/repository/com/mysql/mysql-connector-j/${MS_DRIVER_VER}/mysql-connector-j-${MS_DRIVER_VER}.jar ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/mysql/main

exit 0
