set -eu

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
# Almond:
# https://almond.sh/
# Images available: https://github.com/almond-sh/docker-images

# Disabled packages:
#
# Markdown-kernel:
# https://github.com/vatlab/markdown-kernel
# Error:
#   - Does not work well.

# Some Jupyter lab extensions do not work with jupyter lab 2.0
conda install --quiet --yes \
    'jupyterlab=1.0.4' \
    'jupyterhub=1.0.0'

# Custom pip packages
pip install --upgrade pip && \
    pip install --no-cache-dir \
    pearl \
    s3contents \
    jupyterlab_github


# Custom packages via conda
conda install --quiet --yes \
    qgrid && \
    conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions' \
    'ipysheet' \
    'jupytext' && \
    jupyter nbextensions_configurator enable --user

# Custom extensions
mkdir -p /home/$NB_USER/.local/share/jupyter/nbextensions && \
    cd /home/$NB_USER/.local/share/jupyter/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding && \
    chmod -R go-w vim_binding && \
    jupyter labextension install ipysheet && \
    # TODO ValueError: The extension "jupyterlab_vim" does not yet support the current version of JupyterLab.
    jupyter labextension install jupyterlab_vim && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter labextension install qgrid && \
    jupyter labextension install @jupyterlab/github && \
    # TODO ValueError: The extension "plotly-extension" does not yet support the current version of JupyterLab.
    jupyter labextension install @jupyterlab/plotly-extension


SCALA_VERSION=2.12.8
ALMOND_VERSION=0.6.0
PATH="${HOME}/.local/bin:${PATH}"

mkdir -p ${HOME}/.local/bin && \
    curl -L -o ${HOME}/.local/bin/coursier https://git.io/coursier-cli && \
    chmod +x ${HOME}/.local/bin/coursier && \
    # ensure the JAR of the CLI is in the coursier cache, in the image
    coursier --help && \
    coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
      sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
      --default=true --sources \
      -o almond && \
    ./almond --install --log info --metabrowse && \
    rm almond


