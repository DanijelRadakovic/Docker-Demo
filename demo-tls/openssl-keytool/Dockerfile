FROM openjdk:8-jdk-alpine

LABEL maintainer="danijelradakovic@uns.ac.rs"

WORKDIR /export

RUN apk update && \
    apk add --no-cache openssl && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["openssl"]
