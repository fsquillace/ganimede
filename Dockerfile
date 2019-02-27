FROM jupyter/all-spark-notebook

LABEL maintainer="Filippo Squillace <feel.sqoox@gmail.com>"

USER $NB_UID

# Custom packages via conda
# Jupyter contrib extensions:
# https://github.com/ipython-contrib/jupyter_contrib_nbextensions
# Qgrid:
# https://github.com/quantopian/qgrid
RUN conda install --quiet --yes \
    'pymc3' && \
    conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions' \
    'jupytext' && \
    jupyter nbextensions_configurator enable --user && \
    conda install qgrid && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# Custom extensions
# Install vim-binding which does not have a pip or conda package at the moment
# https://github.com/lambdalisue/jupyter-vim-binding
# Vim for JupyterLab:
# https://github.com/jwkvam/jupyterlab-vim
# TOC:
# https://github.com/jupyterlab/jupyterlab-toc
# DrawIO:
# https://github.com/QuantStack/jupyterlab-drawio
# Qgrid:
# https://github.com/quantopian/qgrid
RUN mkdir -p /home/$NB_USER/.local/share/jupyter/nbextensions && \
    cd /home/$NB_USER/.local/share/jupyter/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding && \
    chmod -R go-w vim_binding && \
    jupyter labextension install jupyterlab_vim && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter labextension install qgrid && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Custom pip packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
    s3contents

