# syntax=docker/dockerfile:1

FROM alpine:latest 

ARG HOME=/root

ENV VERSION=1.0
ENV GIT_HOST="github.com"
ENV REPO="git@github.com:lrbaden/memoir.git"
ENV REPO_DIR="/memoir"
ENV REPO_SYNC_MODE="pull"

# Install dependencies
RUN apk add --no-cache \
    git \
    inotify-tools \
    openssh-client \
    rsync


# Create required files and directories
RUN \
    # ssh
    mkdir -p -m 0700 "$HOME/.ssh" && \
    ssh-keyscan "$GIT_HOST" 2> /dev/null 1>> "$HOME/.ssh/known_hosts" && \
    # project 
    mkdir -p "$REPO_DIR"


# Copy source
COPY "src/" "/usr/src/"

RUN chmod -R +x "/usr/src/"


# Create symlink
RUN for f in $(ls /usr/src/*.sh); do \
        fname="${f##*/}"; name="${fname%.sh}"; link="/usr/local/bin/$name"; \
        ln -s  "$f" "$link"; done


# Set working directory
WORKDIR "$REPO_DIR"


# Manage entrypoint
COPY "entrypoint.sh" "/entrypoint.sh"

RUN chmod 755 "/entrypoint.sh"


ENTRYPOINT [ "/entrypoint.sh" ]
