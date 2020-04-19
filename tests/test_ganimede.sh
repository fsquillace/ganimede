#!/usr/bin/env bash

set -eux

ROOT_DIR="$(dirname $0)/../"

conda create --yes -n jupyter-server
make -f Makefile-conda conda-setup-tools CONDA_ENV=jupyter-server
make -f Makefile-conda conda-run-as-wrappers FILE_TO_WRAP=$ROOT_DIR/tests/test_tools_imports.py CONDA_ENV=jupyter-server
conda env remove -n jupyter-server

conda create --yes -n myenv
make -f Makefile-conda conda-setup-libraries CONDA_ENV=myenv
make -f Makefile-conda conda-run-as-wrappers FILE_TO_WRAP=$ROOT_DIR/tests/test_libraries_imports.py CONDA_ENV=myenv
conda env remove -n myenv

