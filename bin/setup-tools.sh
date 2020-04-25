set -eux

# List of all packages/extensions installed:
#
# Jupyter contrib extensions:
# https://github.com/ipython-contrib/jupyter_contrib_nbextensions
# Qgrid:
# https://github.com/quantopian/qgrid
# Install vim-binding which does not have a pip or conda package at the moment
# https://github.com/lambdalisue/jupyter-vim-binding
# Vim for JupyterLab:
# https://github.com/jwkvam/jupyterlab-vim
# TOC:
# https://github.com/jupyterlab/jupyterlab-toc
# DrawIO:
# https://github.com/QuantStack/jupyterlab-drawio
# ipysheet:
# https://github.com/QuantStack/ipysheet
# GitHub:
# https://github.com/jupyterlab/jupyterlab-github
# Papermill:
# https://github.com/nteract/papermill
# SparkMagic:
# https://github.com/jupyter-incubator/sparkmagic
# Almond:
# https://almond.sh/
# Images available: https://github.com/almond-sh/docker-images

# Disabled packages:
#
# Markdown-kernel:
# https://github.com/vatlab/markdown-kernel
# Error:
#   - Does not work well.

ROOT_DIR="$(dirname $(readlink -f $0))/../"

##############################
## Installation base packages
##############################
# Make sure there are not cached location that are not longer working
hash -r
conda update -y -n base conda -c defaults
# jupyterlab: Some Jupyter lab extensions do not work with jupyter lab 2.0
# pykerberos: Required by sparkmagic
# openjdk: Required by almond
# nodejs version higher than 8 conflicts with jupyterlab-manager extension
conda install --quiet --yes \
    'jupyterlab=1.2.6' \
    gxx_linux-64 \
    jupyter \
    nodejs=8.12.0 \
    openjdk=8.0.152 \
    pykerberos \
    python=3.7
# These extensions needs to be reinstalled such that jupyter will pick the version
# compatible with 1.x
jupyter labextension install @jupyter-widgets/jupyterlab-manager @bokeh/jupyter_bokeh jupyterlab-jupytext


##############################
# Custom pip packages
##############################
pip install --upgrade pip && \
    pip install --no-cache-dir \
    pearl \
    s3contents \
    jupyterlab_github \
    papermill[s3] \
    sparkmagic


##############################
# Custom packages via conda
##############################
conda install --quiet --yes \
    qgrid && \
    conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions' \
    'ipysheet' \
    'jupytext' && \
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
    jupyter labextension install qgrid && \
    jupyter labextension install @jupyterlab/github && \
    jupyter labextension install @jupyterlab/plotly-extension


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


