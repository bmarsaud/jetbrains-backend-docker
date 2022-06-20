FROM adoptopenjdk/openjdk11
LABEL maintainer "Bastien MARSAUD <pro@bastien-marsaud.fr>"

# Arguments
ARG IDE_NAME
ARG IDE_ID
ARG IDE_VERSION
ARG USER_NAME
ARG USER_PASSWORD

# Exposed ports
EXPOSE 22

# Install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y git openssh-client openssh-server

# Create user
RUN useradd -ms /bin/bash $USER_NAME
RUN echo "$USER_NAME:$USER_PASSWORD" | chpasswd

USER $USER_NAME
WORKDIR /home/$USER_NAME

# Download JetBrains IDE
ARG IDE_PATH=.cache/JetBrains/$IDE_ID-$IDE_VERSION
RUN mkdir -p $IDE_PATH
RUN curl -fsSL https://download.jetbrains.com/$IDE_ID/$IDE_NAME-$IDE_VERSION.tar.gz -o $IDE_PATH/installer.tar.gz
RUN tar --strip-components=1 -xzf $IDE_PATH/installer.tar.gz -C $IDE_PATH \
    && rm $IDE_PATH/installer.tar.gz

# Setup IDE for remote dev
RUN ./$IDE_PATH/bin/remote-dev-server.sh registerBackendLocationForGateway

# Start SSH server
USER root
ENTRYPOINT service ssh start && tail -f /dev/null