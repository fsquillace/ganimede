#!/usr/bin/env bash


make conda-create-from-lock-file CONDA_ENV=myenv
conda run -n myenv ./test_imports.py

conda create -q -n myenv2 python=$TRAVIS_PYTHON_VERSION
make conda-update-from-lock-file CONDA_ENV=myenv2
conda run -n myenv2 ./test_imports.py
