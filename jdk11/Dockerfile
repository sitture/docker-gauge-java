ARG VERSION
FROM sitture/docker-gauge-java/base:$VERSION

RUN apk add --no-cache wget libc6-compat openjdk11 && \
    rm -rf /var/cache/apk/*
