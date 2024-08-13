ARG ALPINE_VERSION=3.20.2
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
    unzip \
    ca-certificates \
    sudo

# download and unzip dumb-init
ARG DUMB_INIT_VERSION=1.2.5
ADD https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_x86_64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# setup non-root user
ARG USER=default
RUN adduser -D ${USER} \
    && mkdir -p /etc/sudoers.d \
    && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} \
    && chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}

# download and unzip PocketBase
ARG PB_VERSION=0.22.19
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN sudo unzip /tmp/pb.zip -d /app/

EXPOSE 8080

# start PocketBase
ENTRYPOINT ["sudo", "/usr/local/bin/dumb-init", "--"]
CMD ["/app/pocketbase", "serve", "--http=0.0.0.0:8080"]