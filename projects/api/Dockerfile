ARG GOLANG_VERSION=1.21.1
ARG ALPINE_VERSION=3.17

# make a reference to the cached-layer so we can use it in subsequent
# build targets.
FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} as build

# install dependencies
RUN apk --update add git bash gcc musl-dev openssh-client

# install timezone data and set timezone
RUN apk add --no-cache tzdata
ENV TZ=Etc/UTC

# set the workdir, this has to be outside to GOPATH
# so modules work correctly.
WORKDIR /project/

# Copy source code to the container.
COPY . .

# build a binary & move to /var
RUN CGO_ENABLED=0 go build -o "/var/api"

# expose initial ports
EXPOSE 3002

# --- production stage ---
# https://hub.docker.com/_/alpine/
FROM alpine:${ALPINE_VERSION} AS production

ARG SERVICE_NAME

RUN apk --update add ca-certificates tzdata

# copy the built binary from the build process.
COPY --from=build "/var/api" "/api"

# set the work directory.
WORKDIR /var

# run the binary.
CMD "./api"

# --- development stage ---
# https://hub.docker.com/_/golang/
FROM alpine:${ALPINE_VERSION} AS development

RUN apk update && apk add bash postgresql-client

COPY --from=build "/var/api" "/api"

RUN chmod +x "/api"

# expose debug ${SERVICE_NAME} port.
EXPOSE 3002

ENTRYPOINT ["/api"]
