ARG GOLANG_VERSION=1.23.4
ARG ALPINE_VERSION=3.17

# make a reference to the cached-layer so we can use it in subsequent
# build targets.
FROM golang:1.23.4-alpine as build

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


RUN go mod tidy

# build a binary & move to /var
RUN go build -o "counter"

# expose initial ports
EXPOSE 3002

# --- production stage ---
# https://hub.docker.com/_/alpine/
FROM golang:1.23.4-alpine AS production

ARG SERVICE_NAME

RUN apk --update add ca-certificates tzdata

# copy the built binary from the build process.
COPY --from=build "/var/counter" "/counter"

# set the work directory.
WORKDIR /var

# run the binary.
CMD "./counter"

# --- development stage ---
# https://hub.docker.com/_/golang/
FROM golang:1.23.4-alpine AS development

RUN apk update && apk add bash postgresql-client

COPY --from=build "/project/counter" "/counter"

RUN chmod +x "/counter"

# expose debug ${SERVICE_NAME} port.
EXPOSE 3002

ENTRYPOINT ["/counter"]
