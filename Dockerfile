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

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    # Install packages
    postgresql-client \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Wildfly
USER vscode
RUN mkdir -p ${SERVERS_DIR} \
    && curl -sL https://download.jboss.org/wildfly/${WILDFLY_VER}/wildfly-${WILDFLY_VER}.tar.gz | tar zx -C ${SERVERS_DIR}

# Add Management User(myadmin/P@ssw0rd)
RUN echo "myadmin=ccf3a3beccc44c0369f1612a9e849695" >> ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/mgmt-users.properties \
    && echo -e "\nmyadmin=" >> ${SERVERS_DIR}/wildfly-${WILDFLY_VER}/standalone/configuration/mgmt-groups.properties

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
