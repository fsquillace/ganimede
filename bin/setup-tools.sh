#!/usr/bin/env bash

set -eux

ROOT_DIR="$(dirname $(readlink -f $0))/../"


##############################
## Installation base packages
##############################
# Make sure there are not cached location that are not longer working
hash -r
conda update --yes -n base conda
# Example:
#conda install --yes -c anaconda -c conda-forge \
    #notebook=6.0.3 \
    #jupyterhub=1.1.0 \
    #jupyterlab=1.2.6 \
    #gxx_linux-64=7.3.0 \
    #nodejs=8.12.0 \
    #pykerberos \
    #python=3.7

jupyter labextension install @jupyter-widgets/jupyterlab-manager


##############################
# Custom pip packages
##############################
pip install --upgrade pip && \
    pip install --no-cache-dir \
    s3contents \
    jupyterlab_github \
    papermill[s3] \
    sparkmagic \
    qgrid


##############################
# Custom packages via conda
##############################
conda install --yes -c conda-forge \
    jupyter_contrib_nbextensions \
    ipysheet \
    voila \
    jupytext && \
    jupyter nbextensions_configurator enable --user

##############################
# Custom extensions
##############################
mkdir -p ${HOME}/.local/share/jupyter/nbextensions && \
    cd ${HOME}/.local/share/jupyter/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding && \
    chmod -R go-w vim_binding && \
    jupyter labextension install ipysheet && \
    jupyter labextension install jupyterlab_vim && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter labextension install qgrid2 && \
    jupyter labextension install @jupyterlab/github && \
    jupyter labextension install @jupyterlab/plotly-extension && \
    jupyter labextension install jupyterlab-jupytext && \
    jupyter labextension install @jupyter-voila/jupyterlab-preview

jupyter serverextension enable voila --sys-prefix

jupyter nbextension enable --py --sys-prefix qgrid
jupyter nbextension enable --py --sys-prefix widgetsnbextension

##############################
## Other settings
##############################
PATH="${HOME}/.local/bin:${PATH}"

# SparkMagic
CONDA_DEFAULT_ENV=${CONDA_DEFAULT_ENV:-base}
if [[ "$CONDA_DEFAULT_ENV" == "base" ]]
then
    CONDA_ENV_DIR=$(conda info --base)
else
    CONDA_ENV_DIR=$(grep "/${CONDA_DEFAULT_ENV}$" ~/.conda/environments.txt)
fi
cd $CONDA_ENV_DIR/lib/python3.7/site-packages
jupyter-kernelspec install sparkmagic/kernels/sparkkernel --user
jupyter-kernelspec install sparkmagic/kernels/pysparkkernel --user
jupyter-kernelspec install sparkmagic/kernels/sparkrkernel --user

mkdir -p ${HOME}/.sparkmagic
cp ${ROOT_DIR}/configs/config.json ${HOME}/.sparkmagic
jupyter serverextension enable --py sparkmagic

mkdir -p ${HOME}/livy
cd ${HOME}/livy
LIVY_VERSION=0.7.0-incubating
rm -rf apache-livy-$LIVY_VERSION-bin
wget http://apache.uvigo.es/incubator/livy/$LIVY_VERSION/apache-livy-$LIVY_VERSION-bin.zip
unzip apache-livy-$LIVY_VERSION-bin.zip
rm -rf apache-livy-$LIVY_VERSION-bin.zip

# Almond
if command -v java
then
    # Images available: https://github.com/almond-sh/docker-images
    SCALA_VERSION=2.12.8
    ALMOND_VERSION=0.6.0
    mkdir -p ${HOME}/.local/bin && \
        curl -L -o ${HOME}/.local/bin/coursier https://git.io/coursier-cli && \
        chmod +x ${HOME}/.local/bin/coursier && \
        # ensure the JAR of the CLI is in the coursier cache, in the image
        coursier --help && \
        coursier bootstrap \
          --force -r jitpack \
          -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
          sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
          --default=true --sources \
          -o almond && \
        ./almond --force --install --log info --metabrowse && \
        rm -f almond
else
    echo WARNING: Java is not installed! Almond will not be installed.
fi

