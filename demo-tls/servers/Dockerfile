FROM node:alpine3.11 AS front

LABEL maintainer="danijelradakovic@uns.ac.rs"

WORKDIR /usr/src/server 
COPY Servers-Front .
RUN ["npm", "install"]
RUN [ "npm", "run", "build", "--prod"]


FROM maven:3.6.3-ibmjava-8-alpine AS appServer

WORKDIR /usr/src/server
COPY Servers .
COPY --from=front /usr/src/server/dist/servers ./src/main/resources/static
RUN ["mvn", "package", "-DskipTests"]


FROM openjdk:8-jdk-alpine
EXPOSE 8080
WORKDIR /app

COPY --from=appServer /usr/src/server/target/servers.jar ./


CMD ["java", "-jar", "servers.jar"]