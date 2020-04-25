FROM jupyter/all-spark-notebook

LABEL maintainer="Filippo Squillace <feel.sqoox@gmail.com>"

ENV PATH="/home/jovyan/.local/bin:${PATH}"

USER $NB_UID

RUN mkdir -p ganimede
COPY --chown=jovyan:users . ganimede/

RUN cd ganimede && \
        make -f Makefile-conda conda-setup-tools && \
        make -f Makefile-conda conda-setup-libraries && \
        conda clean --all -f -y && \
        npm cache clean --force && \
        rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
        rm -rf /home/$NB_USER/.cache/yarn && \
        rm -rf /home/$NB_USER/.node-gyp && \
        fix-permissions $CONDA_DIR && \
        fix-permissions /home/$NB_USER

COPY ganimede/bin/start-ganimede.sh /usr/local/bin/
CMD ["start-ganimede.sh"]
