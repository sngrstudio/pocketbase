FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

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