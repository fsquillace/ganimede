FROM jupyter/all-spark-notebook

LABEL maintainer="Filippo Squillace <feel.sqoox@gmail.com>"

USER $NB_UID

# Custom packages
RUN conda install --quiet --yes \
    'pymc3' && \
    conda install --quiet --yes -c conda-forge \
    'jupyter_contrib_nbextensions' && \
    jupyter nbextensions_configurator enable --user && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# Install vim-binding which does not have a pip or conda package at the moment
# https://github.com/lambdalisue/jupyter-vim-binding
# Vim for JupyterLab:
# https://github.com/jwkvam/jupyterlab-vim
RUN mkdir -p /home/$NB_USER/.local/share/jupyter/nbextensions && \
    cd /home/$NB_USER/.local/share/jupyter/nbextensions && \
    git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding && \
    chmod -R go-w vim_binding && \
    jupyter labextension install jupyterlab_vim && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

