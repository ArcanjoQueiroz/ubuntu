#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

cp ${SCRIPT_PATH}/../install.sh ${SCRIPT_PATH}
docker build -t ubuntu-script:1.0.1-ubuntu-19.04 .
rm install.sh
