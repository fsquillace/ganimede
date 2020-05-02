#!/usr/bin/env bash

set -eux

# Disabled packages:
#
# Imbalanced learn: Data augmentation. Allows to under-sampling/over-sampling data.
# https://imbalanced-learn.readthedocs.io/en/stable/
# GluonTS: Probabilistic Time Series Modeling
# https://gluon-ts.mxnet.io/
# Error raised during build:
#   - gluonts 0.3.2 has requirement mxnet<1.5.*,>=1.3.1,
#     but you'll have mxnet 1.5.0 which is incompatible.
#   - gluonts 0.3.2 has requirement numpy==1.14.*,
#     but you'll have numpy 1.17.0 which is incompatible.
#

##############################
## Installation base packages
##############################
# Make sure there are not cached location that are not longer working
hash -r
conda update --yes -n base conda
conda install --quiet --yes \
    python=3.7


##############################
# Custom pip packages
##############################
pip install --upgrade pip
pip install --no-cache-dir \
    mxnet gluoncv gluonnlp \
    xgboost \
    nltk \
    keras \
    qgrid \
    pyarrow \
    altair vega_datasets \
    tensorflow \
    koalas \
    pyspark \
    gensim \
    tqdm \
    textdistance \
    luigi \
    PyAthena \
    dask[complete] \
    spacy \
    torch \
    stanza \
    spacy-lookups-data \
    joblib

python -m spacy download en_core_web_sm


##############################
# Custom packages via conda
##############################
conda install --quiet --yes \
    pymc3
conda install --quiet --yes -c conda-forge \
    shap \
    ipysheet
conda install --quiet --yes -c dglteam dgl

