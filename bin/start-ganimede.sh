#!/usr/bin/env bash

set -eu

JUPYTER_CMD=${JUPYTER_CMD:-start-notebook.sh}
${HOME}/livy/apache-livy-0.7.0-incubating-bin/bin/livy-server start

${JUPYTER_CMD} "$@"
