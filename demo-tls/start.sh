#! /bin/bash

BASE_DIR=$(pwd)
TLS_DIR=${BASE_DIR}/tls
DOCKER_COMPOSE_TEMPLATE=${BASE_DIR}/docker-compose-template.yml
DOCKER_COMPOSE=${BASE_DIR}/docker-compose.yml

KEY_SIZE=${2:-4096}

SERVERS_NAME=${3:-servers}
SERVERS_ALIAS=${4:-servers}
SERVERS_KEYSTORE_PASSWORD=${5:-password}

REPORT_NAME=${6:-report}
REPORT_ALIAS=${7:-report}
REPORT_KEYSTORE_PASSWORD=${8:-password}

CLIENT_NAME=${9:-client}
CLIENT_ALIAS=${10:-client}
CLIENT_KEYSTORE_PASSWORD=${11:-password}

LOGAN_NAME=${12:-logan}
LOGAN_ALIAS=${13:-logan}
LOGAN_KEYSTORE_PASSWORD=${14:-password}

RMQ_NAME=${15:-rabbitmq}

function generateDockerCompose() {
  # sed on MacOSX does not support -i flag with a null extension. We will use
  # 't' for our back-up's extension and delete it at the end of the function
  ARCH=$(uname -s | grep Darwin)
  if [[ "$ARCH" == "Darwin" ]]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi

  # Copy the template to the file that will be modified to add certificates
  cp "${DOCKER_COMPOSE_TEMPLATE}" "${DOCKER_COMPOSE}" || exit

  # The next steps will replace the template's contents with the
  # actual values of the certificates and private key files
  sed ${OPTS} \
      -e "s/SERVERS_NAME/${SERVERS_NAME}/g" \
      -e "s/SERVERS_ALIAS/${SERVERS_ALIAS}/g" \
      -e "s/SERVERS_KEYSTORE_PASSWORD/${SERVERS_KEYSTORE_PASSWORD}/g" \
      -e "s/REPORT_NAME/${REPORT_NAME}/g" \
      -e "s/REPORT_ALIAS/${REPORT_ALIAS}/g" \
      -e "s/REPORT_KEYSTORE_PASSWORD/${REPORT_KEYSTORE_PASSWORD}/g" \
      -e "s/LOGAN_NAME/${LOGAN_NAME}/g" \
      -e "s/LOGAN_ALIAS/${LOGAN_ALIAS}/g" \
      -e "s/LOGAN_KEYSTORE_PASSWORD/${LOGAN_KEYSTORE_PASSWORD}/g" \
      -e "s/RMQ_NAME/${RMQ_NAME}/g" \
      "${DOCKER_COMPOSE}"

  if [[ "$ARCH" == "Darwin" ]]; then
    rm "${DOCKER_COMPOSE}t"
  fi
}

function generateCertificates() {
  # Clean up previous generated certificates
  rm -rf "${TLS_DIR}"/ca "${TLS_DIR}"/certs "${TLS_DIR}"/crl

  docker run \
       -it \
       --rm \
       --entrypoint sh \
       --mount "type=bind,source=${TLS_DIR},destination=/export" \
       --user "$(id -u):$(id -g)" \
       danijelradakovic/openssl-keytool \
       gen.sh "${KEY_SIZE}" \
       "${SERVERS_NAME}" "${SERVERS_ALIAS}" "${SERVERS_KEYSTORE_PASSWORD}" \
       "${REPORT_NAME}"  "${REPORT_ALIAS}"  "${REPORT_KEYSTORE_PASSWORD}"  \
       "${CLIENT_NAME}"  "${CLIENT_ALIAS}"  "${CLIENT_KEYSTORE_PASSWORD}"  \
       "${LOGAN_NAME}"   "${LOGAN_ALIAS}"   "${LOGAN_KEYSTORE_PASSWORD}"   \
       "${RMQ_NAME}"
}

if [ "${1}" == '-g' ]; then
  generateCertificates
  generateDockerCompose
fi

docker-compose up --build
