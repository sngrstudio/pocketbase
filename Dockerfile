FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d

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