FROM postgres:15-alpine3.18

RUN apk add \
    postgresql-contrib

ARG DIR="."

COPY $DIR/projects/psql/uuid_ossp.sql /docker-entrypoint-initdb.d/10_uuid_ossp.sql

COPY $DIR/projects/api/sqlc/booking/booking_schema.sql /docker-entrypoint-initdb.d/15_booking_schema.sql

RUN chmod a+r /docker-entrypoint-initdb.d/*

