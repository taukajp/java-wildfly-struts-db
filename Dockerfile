# FROM mcr.microsoft.com/devcontainers/java:11-bullseye
ARG VARIANT=11-bullseye
FROM mcr.microsoft.com/devcontainers/java:${VARIANT}

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ARG APP_NAME
ENV APP_NAME=${APP_NAME:-myapp}

WORKDIR /workspaces/${APP_NAME}

ARG SERVERS_DIR=/home/vscode/.rsp/redhat-server-connector/runtimes/installations
ARG WILDFLY_VER=23.0.2.Final
ARG RSP_SERVERS_DIR=/home/vscode/.rsp/redhat-server-connector/servers
ARG PG_DRIVER_VER=42.6.0
ARG MS_DRIVER_VER=8.1.0
ARG OR_DRIVER_VER=23.3.0.23.09

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    # Install packages
    postgresql-client \
    default-mysql-client \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Wildfly
USER vscode
RUN mkdir -p ${SERVERS_DIR} \
    && curl -sL https://download.jboss.org/wildfly/${WILDFLY_VER}/wildfly-${WILDFLY_VER}.tar.gz | tar zx -C ${SERVERS_DIR}

# Add Management User(myadmin/P@ssw0rd)
RUN echo "myadmin=ccf3a3beccc44c0369f1612a9e849695" >> ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/mgmt-users.properties \
    && echo -e "\nmyadmin=" >> ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/mgmt-groups.properties

# Install JDBC driver as module
RUN mkdir -p ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/org/postgresql/main \
    && curl -sL https://repo1.maven.org/maven2/org/postgresql/postgresql/${PG_DRIVER_VER}/postgresql-${PG_DRIVER_VER}.jar -o ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/org/postgresql/main/postgresql-${PG_DRIVER_VER}.jar
COPY --chown=vscode .devcontainer/postgres/module.xml ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/org/postgresql/main

RUN mkdir -p ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/mysql/main
# COPY --chown=vscode .devcontainer/mysql/mysql-connector-j-${MS_DRIVER_VER}.jar ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/mysql/main
COPY --chown=vscode .devcontainer/mysql/module.xml ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/mysql/main

RUN mkdir -p ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/oracle/main
# COPY --chown=vscode .devcontainer/oracle/ojdbc11-${OR_DRIVER_VER}.jar ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/oracle/main
COPY --chown=vscode .devcontainer/oracle/module.xml ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/modules/system/layers/base/com/oracle/main

# Add Driver & Datasource
# RUN sed -i -e '/driver name="h2"/e cat .devcontainer/pg_driver.part' -e '/jndi-name="java:jboss\/datasources\/ExampleDS"/e cat .devcontainer/pg_datasource.part' \
  # ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/standalone.xml

RUN mkdir -p ${RSP_SERVERS_DIR}
COPY --chown=vscode .devcontainer/wildfly-${WILDFLY_VER} ${RSP_SERVERS_DIR}

# RUN sudo -u vscode sh -c 'mkdir -p /home/vscode/.m2'
USER vscode
RUN mkdir -p /home/vscode/.m2 \
    && cat <<EOF > /home/vscode/.m2/settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository>${PWD}/.m2/repository</localRepository>
</settings>
EOF
