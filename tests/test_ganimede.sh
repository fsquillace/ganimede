#!/usr/bin/env bash

set -eux

ROOT_DIR="$(dirname $0)/../"

conda create --yes -n jupyter-server python=3.7 gxx_linux-64
make conda-setup-tools CONDA_ENV=jupyter-server
conda run -n jupyter-server $ROOT_DIR/tests/test_tools_imports.py | grep "import success"
conda env remove -n jupyter-server

conda create --yes -n myenv python=3.7 gxx_linux-64
make conda-setup-libraries CONDA_ENV=myenv
conda run -n myenv $ROOT_DIR/tests/test_libraries_imports.py | grep "import success"
conda env remove -n myenv

