#!/bin/bash
set -e

###
# Start get docker host IP
# Copied from https://github.com/thecodingmachine/docker-images-php/blob/v3/utils/docker-entrypoint-as-root.sh
###
if [ -z "$DOCKER_REMOTE_HOST" ]; then
  export DOCKER_REMOTE_HOST=`/sbin/ip route|awk '/default/ { print $3 }'`

  set +e
  # On Windows and MacOS with Docker >= 18.03, check that host.docker.internal exists. it true, use this.
  # Linux systems can report the value exists, but it is bound to localhost. In this case, ignore.
  host -t A host.docker.internal &> /dev/null
  if [[ $? == 0 ]]; then
      # The host exists.
      DOCKER_HOST_INTERNAL=`host -t A host.docker.internal | awk '/has address/ { print $4 }'`
      if [ "$DOCKER_HOST_INTERNAL" != "127.0.0.1" ]; then
          export DOCKER_REMOTE_HOST=$DOCKER_HOST_INTERNAL
          export REMOTE_HOST_FOUND=1
      fi
  fi

  if [[ "$REMOTE_HOST_FOUND" != "1" ]]; then
    # On mac with Docker < 18.03, check that docker.for.mac.localhost exists. it true, use this.
    # Linux systems can report the value exists, but it is bound to localhost. In this case, ignore.
    host -t A docker.for.mac.localhost &> /dev/null

    if [[ $? == 0 ]]; then
        # The host exists.
        DOCKER_FOR_MAC_REMOTE_HOST=`host -t A docker.for.mac.localhost | awk '/has address/ { print $4 }'`
        if [ "$DOCKER_FOR_MAC_REMOTE_HOST" != "127.0.0.1" ]; then
            export DOCKER_REMOTE_HOST=$DOCKER_FOR_MAC_REMOTE_HOST
        fi
    fi
  fi
  set -e
fi

unset DOCKER_FOR_MAC_REMOTE_HOST
unset REMOTE_HOST_FOUND
###
# End get docker host IP
###

echo "# Local development domains" | sudo tee -a /etc/hosts >/dev/null
while read -r LINE; do
    OUTPUT_LINE=$(sed "s/GATEWAY_WEB/${DOCKER_REMOTE_HOST}/g" <<< "$LINE")

    echo "${OUTPUT_LINE}" | sudo tee -a /etc/hosts >/dev/null
done < /usr/local/bin/development-domains.list
