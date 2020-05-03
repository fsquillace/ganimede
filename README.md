# Ganimede Jupyter Notebook

[![Build status](https://api.travis-ci.org/fsquillace/ganimede.png?branch=master)](https://travis-ci.org/fsquillace/ganimede)

## Description

Ganimede is a Jupyter Notebook server that contains additional Jupyter
tools and libraries in order to get a more complete solution without
the hassle of installing and configuring them.
Ganimede can be used either as a Docker container or inside conda environments.
For more details on how to setup Ganimede in conda environment look at the
[section](#manage-conda-environments) below.

## Quickstart

To run the Ganimede docker container:

```
make docker-pull
make docker-run
```

Go to `http://localhost:8888` to access to the JupyterLab.

## List of available packages/tools

The docker image is built on top of
[all-spark-notebook](https://github.com/jupyter/docker-stacks) image.
The following are the package/tools provided by Ganimede apart from the ones already
available in `all-spark-notebok`.

### Jupyter tools

- [Almond](https://almond.sh/)
- [DrawIO](https://github.com/QuantStack/jupyterlab-drawio)
- [IPySheet](https://github.com/QuantStack/ipysheet)
- [JupyText](https://github.com/mwouts/jupytext)
- [Jupyter Contrib extensions](https://github.com/ipython-contrib/jupyter_contrib_nbextensions)
- [Jupyter Vim binding](https://github.com/lambdalisue/jupyter-vim-binding)
- [JupyterLab Debugger](https://github.com/jupyterlab/debugger)
- [JupyterLab Git](https://github.com/jupyterlab/jupyterlab-git)
- [JupyterLab Github](https://github.com/jupyterlab/jupyterlab-github)
- [JupyterLab TOC](https://github.com/jupyterlab/jupyterlab-toc)
- [JupyterLab Vim](https://github.com/jwkvam/jupyterlab-vim)
- [Livy](https://livy.apache.org/)
- [Papermill](https://github.com/nteract/papermill)
- [Qgrid](https://github.com/quantopian/qgrid)
- [S3Contents](https://github.com/danielfrg/s3contents)
- [SparkMagic](https://github.com/jupyter-incubator/sparkmagic)
- [Voila](https://github.com/voila-dashboards/voila)

### Libraries available


#### Data processing libraries

- [dask](https://dask.org/)
- [joblib](https://joblib.readthedocs.io/en/latest/)
- [koalas](https://github.com/databricks/koalas)
- [luigi](https://luigi.readthedocs.io/en/latest/#)
- [pyarrow](https://pypi.org/project/pyarrow/)
- [pyathena](https://pypi.org/project/PyAthena/)
- [tqdm](https://github.com/tqdm/tqdm)

#### Data visualization libraries

- [altair](https://altair-viz.github.io/index.html)
- [ipysheet](https://github.com/QuantStack/ipysheet)
- [qgrid](https://github.com/quantopian/qgrid)

#### NLP related libraries

- [gensim](https://radimrehurek.com/gensim/)
- [gluon-nlp](https://gluon-nlp.mxnet.io/)
- [nltk](https://www.nltk.org/)
- [spacy](https://spacy.io/)
- [textdistance](https://pypi.org/project/textdistance/)

#### Machine learning libraries

- [dgl](https://www.dgl.ai/pages/start.html)
- [gluon-cv](https://gluon-cv.mxnet.io/)
- [keras](https://keras.io/)
- [mxnet](https://mxnet.apache.org/)
- [pymc3](https://docs.pymc.io/)
- [shap](https://github.com/slundberg/shap)
- [tensorflow](https://www.tensorflow.org/)
- [xgboost](https://xgboost.ai/)

## Manage Docker images

To pull Ganimede from Docker Hub:
```
make docker-pull
```

To build the Ganimede Docker image:
```
make docker-build
```

To remove an old image:

```
# Get list of all existing images
docker images
# To clean up disk with old images
docker image rm <name-image>
```

## Manage Docker containers

### Basic commands
To see all containers (even the ones no longer running):
```
docker ps -a
```

To kill a running container (for gracefully stop use `stop` command instead):
```
docker kill <container-id>
```

To remove old containers (use `--rm` when using `run` command to avoid this annoying step):
```
docker rm <container-id>
```

### Start container

To run the Docker container:
```
make docker-run WORK_DIR="/path/to/workdir"
```

To run the Docker container in background:
```
make docker-background-run WORK_DIR="/path/to/workdir"
```

For more information take a look [here](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html).

To automatically start container at boot time:
```
make docker-boot-run WORK_DIR="/path/to/workdir"
```

For more information take a look [here](https://docs.docker.com/config/containers/start-containers-automatically/).

#### Persist Jupyter user settings

The folder `.jupyter` contains the jupyter settings.
Add the following mount when running the container, considering your settings
are located in `/home/username/jupyter-config`:
```
     -v /home/username/jupyter-config/bash_history:/home/jovyan/.bash_history \
     -v /home/username/jupyter-config/jupyter:/home/jovyan/.jupyter
```

#### Using systemd (recommended)

If your system supports systemd you can run Ganimede as a Systemd service

```
make start-systemd-service WORK_DIR="/path/to/workdir"
```

## Restart docker via systemd

```
sudo systemctl restart docker
```

## Run shell in container

To run a shell in the Docker container:
```
make docker-shell
```

## Clean up unused containers, networks, volumes and images

```
docker system prune --all --volumes
```

## Manage Conda environments

There are scenarios where the Jupyter tools and the python libraries are in
different conda environments. You can use the scripts in `bin/` directory to
setup specific set of packages depending on the environment.

For example to setup the Ganimede tools in the conda environment
`jupyter-server` and setup python libraries to `myenv`:

```
make -f Makefile-conda conda-setup-tools CONDA_ENV=jupyter-server
make -f Makefile-conda conda-setup-libraries CONDA_ENV=myenv
```

