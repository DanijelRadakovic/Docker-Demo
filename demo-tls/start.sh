#! /bin/bash

BASE_DIR=${1:-$(pwd)}
TLS_DIR=${BASE_DIR}/tls

# Clean up previous generated certificates
rm -rf ${TLS_DIR}/ca ${TLS_DIR}/certs ${TLS_DIR}/crl

# Generate certificates
docker run \
       -it \
       --rm \
       --entrypoint sh \
       --mount "type=bind,source=${TLS_DIR},destination=/export" \
       --user "$(id -u):$(id -g)" \
       danijelradakovic/openssl-keytool \
       gen.sh


