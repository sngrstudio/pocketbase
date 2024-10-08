FROM alpine:3.20.2

RUN apk add --no-cache \
    unzip \
    ca-certificates

# setup non-root user
ARG USER=default
RUN adduser -D ${USER} 

USER ${USER}
WORKDIR /home/${USER}

# download and unzip PocketBase
ARG PB_VERSION=0.22.19
ADD --chown=default:default https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip ./.tmp/pb.zip
RUN unzip ./.tmp/pb.zip -d . && rm -rf .tmp

EXPOSE 8080

# start PocketBase
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080"]