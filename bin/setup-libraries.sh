set -eu

# List of all packages installed:
#
# Qgrid:
# https://github.com/quantopian/qgrid
# DGL: Deep learning on graphs
# https://www.dgl.ai/pages/start.html
# SHAP: Explains why the output of any ML model by analyzing the trained model
# https://github.com/slundberg/shap
# Qgrid:
# https://github.com/quantopian/qgrid
# ipysheet:
# https://github.com/QuantStack/ipysheet
# GluonCV: a Deep Learning Toolkit for Computer Vision
# https://gluon-cv.mxnet.io/
# GluonNLP: NLP made easy
# https://gluon-nlp.mxnet.io/
# XGBoost: Advanced regressor and classifier
# https://xgboost.ai/
# NLTK: human language data for the purpose of building chatbots
# https://www.nltk.org/
# Keras: Deep learning and neural networks
# https://keras.io/
# Tensorflow: Neural network builder
# https://www.tensorflow.org/
# JobLib:
# https://joblib.readthedocs.io/en/latest/

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

# Custom pip packages
pip install --upgrade pip && \
    pip install --no-cache-dir \
    mxnet gluoncv gluonnlp \
    xgboost \
    nltk \
    keras \
    tensorflow \
    koalas \
    pyspark \
    joblib


# Custom packages via conda
conda install --quiet --yes \
    'pymc3' qgrid && \
    conda install --quiet --yes -c conda-forge \
    'shap' && \
    conda install --quiet --yes -c dglteam dgl

